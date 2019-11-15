class ProductTreatmentPhasesController < ApplicationController
  before_action :set_product_treatment_phase, only: [:show, :update, :destroy]

  # GET /product_treatment_phases
  def index
    @product_treatment_phases = ProductTreatmentPhase.all

    render json: @product_treatment_phases
  end

  # GET /product_treatment_phases/1
  def show
    render json: @product_treatment_phase
  end

  # POST /product_treatment_phases
  def create

    @product_treatment_phase = ProductTreatmentPhase.new(product_treatment_phase_params)

    puts '--->>>Imprimiento el Elemento<<<---'
    puts @product_treatment_phase.inspect

                
    if @product_treatment_phase.save 

      puts "--->>>Se guardo<<<---"
      # render JSON.product_treatment_phase do
      #   JSON.weight @product_treatment_phase.weight
      #   JSON.phase_id @product_treatment_phase.phase_id
      #   JSON.product_treatment_phase_id @product_treatment_phase.product_treatment_phase_id
      #   JSON.product_treatments_attributes do
      #     JSON.cost  @product_treatment_phase.product_treatments.cost
      #     JSON.weight @product_treatment_phase.product_treatments.weight
      #     JSON.waste @product_treatment_phase.product_treatments.waste
      #     JSON.treatment_id @product_treatment_phase.product_treatments.treatment_id
      #   end
      # end

    else
      puts "--->>>No se guardo<<<---"
      render json: @product_treatment_phase.errors, status: :unprocessable_entity

    end 

    

    
    # @product_treatment_phase.cost = 0 
    # puts "Dentro del create"

    # #if @product_treatment_phase.save  
      
    #   #validamos que sea hijo de una face 
    #   if !@product_treatment_phase.product_treatment_phase_id.nil? 

    #       puts "Primer if"
    #       begin 
    #         lotClean = ProductTreatmentPhase.where(id: @product_treatment_phase.product_treatment_phase_id, product_treatment_phase_id: nil).last.lots.where(weight: 0)
    #       rescue
    #         lotClean = 0 
    #       end

    #       #validamos que el lote de la face anterior este seteado en 0
    #       if lotClean.nil? 

    #         puts "Entre al if de lotClean"
    #         lot_previous = ProductTreatmentPhase.find_by(id: @product_treatment_phase.product_treatment_phase_id).lots
    #         @product_treatment_phase.cost = lot_previous.last.cost
    #         @product_treatment_phase.weight = lot_previous.last.weight
    #         Lot.create(cost: @product_treatment_phase.cost, weight: @product_treatment_phase.weight, waste: 0.0, available: 0.0, product_treatment_phase_id:@product_treatment_phase.id)        
    
    #       else
            
    #         puts "Entro al ElSE de lotClean"
    #         lot = ProductTreatmentPhase.find(@product_treatment_phase.product_treatment_phase_id).lots
    #         cost_treatments = ProductTreatmentPhase.find(@product_treatment_phase.product_treatment_phase_id).product_treatments.sum(:cost) ##and lot.last.cost == 0

    #         if !@product_treatment_phase.product_treatment_phase_id.nil? and @product_treatment_phase.phase_id == 2 and lot.last.cost == 0
    
    #           lot_cost = Lot.find_by(id: lot.ids).quantities.sum(:cost) 
    #           lot_weight = Lot.find_by(id: lot.ids).quantities.sum(:weight) 

    #           if @product_treatment_phase.weight <= lot_weight
    #             #cost = @product_treatment_phase.cost
    #             weight = @product_treatment_phase.weight
    #             previous_cost_kilo_phase = ( lot_cost / lot_weight )
    #             new_cost = previous_cost_kilo_phase
    #             new_weight = lot_weight - weight
    #             puts "-->>> Entro al if de costos <<<---"
    #             puts "previous_cost_kilo_phase: #{ previous_cost_kilo_phase } = ( lot_cost #{ lot_cost } / lot_weight #{ lot_weight }) "
    #             puts "( previous_cost_kilo_phase: #{ previous_cost_kilo_phase } + cost_treatments #{ cost_treatments } ) / #{ weight }"
    #             puts "new_weight: #{ new_weight } lot_weight: #{ lot_weight } - weight: #{ weight }"

    #             #acutaliza el cost y weight la fase 0 
    #             ProductTreatmentPhase.find_by(id: @product_treatment_phase.product_treatment_phase_id).update(cost: new_cost, weight: new_weight)
    #             #actualizo el cost la fase actual(fase 1)
    #             @product_treatment_phase.cost= new_cost
    #             #actualizo el cost y weight del lote de la face anterior
    #             ProductTreatmentPhase.find_by(id: @product_treatment_phase.product_treatment_phase_id).lots.update(cost: new_cost, weight: new_weight)
               
    #             if @product_treatment_phase.save 
            
    #               Lot.create(cost: new_cost, weight: @product_treatment_phase.weight, waste: 0.0, available: 0.0, product_treatment_phase_id:@product_treatment_phase.id)
    #               render json: @product_treatment_phase, status: :created, location: @product_treatment_phase

    #             else

    #               render json: @product_treatment_phase.errors, status: :unprocessable_entity

    #             end 
              
    #           else  
    #             render json: { message: "El peso ingresado es mayor al del inventario" }
    #           end

    #         else 

    #           puts "--->>> No soy primera face <<<---"
    #           cost_phase_previous = lot.last.cost
    #           weight_phase_previous = lot.last.weight
              
    #           if @product_treatment_phase.weight <= weight_phase_previous
    #             #costo de la face anterior con los tratamientos 
    #             cost_phase_previous_with_treatments = ((cost_phase_previous * @product_treatment_phase.weight) + cost_treatments) /  @product_treatment_phase.weight
    #             weight_phase_previous = weight_phase_previous - @product_treatment_phase.weight

    #             new_cost = cost_phase_previous_with_treatments
    #             new_weight = weight_phase_previous

    #             #acutaliza el cost y weight la fase anterior 
    #             ProductTreatmentPhase.find_by(id: @product_treatment_phase.product_treatment_phase_id).update(cost: new_cost, weight: new_weight)
    #             #actualizo el cost la fase actual
    #             @product_treatment_phase.cost = new_cost
    #             #actualizo el cost y weight del lote de la face anterior
    #             ProductTreatmentPhase.find_by(id: @product_treatment_phase.product_treatment_phase_id).lots.update(cost: new_cost, weight: new_weight)
    #             #creo el lote de la fase actual
                
    #             if @product_treatment_phase.save 

    #               Lot.create(cost: new_cost, weight: @product_treatment_phase.weight, waste: 0.0, available: 0.0, product_treatment_phase_id:@product_treatment_phase.id)
    #               render json: @product_treatment_phase, status: :created, location: @product_treatment_phase
                  
    #             else
    #               render json: @product_treatment_phase.errors, status: :unprocessable_entity
    #             end   

    #           else     
    #             render json: { message: "El peso ingresado es mayor al del inventario" }
    #           end

    #         end 
    #       end       
    #   end  
    
    #  render json: @product_treatment_phase, status: :created, location: @product_treatment_phase
    #else
    #  render json: @product_treatment_phase.errors, status: :unprocessable_entity
    #end 

  end

  # PATCH/PUT /product_treatment_phases/1
  def update
    if @product_treatment_phase.update(product_treatment_phase_params)
      render json: @product_treatment_phase
    else
      render json: @product_treatment_phase.errors, status: :unprocessable_entity
    end
  end

  # DELETE /product_treatment_phases/1
  def destroy
    @product_treatment_phase.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_treatment_phase
      @product_treatment_phase = ProductTreatmentPhase.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_treatment_phase_params
      params.require(:product_treatment_phase).permit(
        :cost ,
        :weight, 
        :phase_id, 
        :product_treatment_phase_id,
        product_treatments_attributes: [ :cost, :weight, :waste, :treatment_id ]
      )
    end
end
