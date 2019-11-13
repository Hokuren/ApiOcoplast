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

    puts "Dentro del create"

    if @product_treatment_phase.save  
      
      #validamos que sea hijo de una face 
      if !@product_treatment_phase.product_treatment_phase_id.nil? 

          puts "Primer if"
          begin 
            lotClean = ProductTreatmentPhase.where(id: @product_treatment_phase.product_treatment_phase_id, product_treatment_phase_id: nil).last.lots.where(cost: 0)
          rescue
            lotClean = 0 
          end

          #validamos que el lote de la face anterior este seteado en 0
          if lotClean.nil? 
            puts "Entre al if de lotClean"
            lot_previous = ProductTreatmentPhase.find_by(id: @product_treatment_phase.product_treatment_phase_id).lots
            @product_treatment_phase.cost = lot_previous.last.cost
            @product_treatment_phase.weight = lot_previous.last.weight
            Lot.create(cost: @product_treatment_phase.cost, weight: @product_treatment_phase.weight, waste: 0.0, available: 0.0, product_treatment_phase_id:@product_treatment_phase.id)        
            #falta restar el face anterior 
            #falta crear el lote 
          else
            puts "Entro al ElSE de lotClean"
            lot = ProductTreatmentPhase.find(@product_treatment_phase.product_treatment_phase_id).lots
            
            if !@product_treatment_phase.product_treatment_phase_id.nil? and @product_treatment_phase.phase_id = 2
              lot_cost = Lot.find_by(id: lot.ids).quantities.sum(:cost) 
              lot_weight = Lot.find_by(id: lot.ids).quantities.sum(:weight) 
              cost = @product_treatment_phase.cost
              weight = @product_treatment_phase.weight
              new_cost = lot_cost - cost
              new_weight = lot_weight - weight
            else 
              new_cost = @product_treatment_phase.cost
              new_weight = @product_treatment_phase.weight
            end 

            ProductTreatmentPhase.find_by(id: @product_treatment_phase.product_treatment_phase_id).update(cost: new_cost, weight: new_weight)
            puts "Primer Update"
            ProductTreatmentPhase.find_by(id: @product_treatment_phase.product_treatment_phase_id).lots.update(cost: new_cost, weight: new_weight)
            puts "Segundo Update"
            Lot.create(cost: @product_treatment_phase.cost, weight: @product_treatment_phase.weight, waste: 0.0, available: 0.0, product_treatment_phase_id:@product_treatment_phase.id)
            puts "lote Creado"
          end       
      end  

      render json: @product_treatment_phase, status: :created, location: @product_treatment_phase
    else
      render json: @product_treatment_phase.errors, status: :unprocessable_entity
    end 

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
      params.require(:product_treatment_phase).permit(:cost, :weight, :phase_id, :product_treatment_phase_id)
    end
end
