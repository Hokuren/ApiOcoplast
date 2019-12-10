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
    
    @product_treatment_phase = product_treatment_phase_params 

    phase_id_previous = params[:phase_id_previous]

    last_product_treatment_phase = ProductTreatmentPhase.last_by_product_per_phase(@product_treatment_phase[:product_id],phase_id_previous)

    @product_treatment_phase[:product_treatment_phase_id] = last_product_treatment_phase.nil? ? nil : last_product_treatment_phase.id

    inventary = Lot.by_product_treatment_phase(@product_treatment_phase[:product_treatment_phase_id])

    if @product_treatment_phase[:weight] <= inventary.weight
        
        treatments = Treatment.all

        cost_treatments = 0
    
        ProductTreatmentPhase.transaction do 

            @product_treatment_phase[:product_treatments_attributes].each do |product_treatment|
        
                if product_treatment[:treatment_id].nil? 
                    treatment = treatments.select{ |element| element.name==product_treatment[:treatment_new_name]}.last
                    if treatment.nil?
                        treatment = Treatment.create(name: product_treatment[:treatment_new_name] )
                    end
                    product_treatment[:treatment_id] = treatment.id
                    cost_treatments = cost_treatments + product_treatment[:cost]
                end 
            end

            product_treatment_phase_new = ProductTreatmentPhase.new(
                weight: @product_treatment_phase[:weight], 
                phase_id: @product_treatment_phase[:phase_id],
                product_id: @product_treatment_phase[:product_id],
                product_treatment_phase_id: @product_treatment_phase[:product_treatment_phase_id] || nil,
                product_treatments_attributes: @product_treatment_phase[:product_treatments_attributes].map{ |phase| { "cost" => phase[:cost], "treatment_id" => phase[:treatment_id] } }
            )       

            product_treatment_phase_new.cost = 0 

            #validamos que tenga una face anterior 
            if !product_treatment_phase_new.product_treatment_phase_id.nil? 
     
                lot = ProductTreatmentPhase.find(product_treatment_phase_new.product_treatment_phase_id).lot
    
                cost_phase_previous = lot.cost
                weight_phase_previous = lot.weight
            
                if product_treatment_phase_new.weight <= weight_phase_previous
    
                    product_treatment_phases = lot.product_treatment_phases.order(created_at: :asc).where("weight > 0")
    
                    cost_phase_previous_with_treatments = ((( cost_phase_previous * product_treatment_phase_new.weight) + cost_treatments) / product_treatment_phase_new.weight )
                    weight_phase_previous = weight_phase_previous - product_treatment_phase_new.weight

                    new_cost = cost_phase_previous_with_treatments
                    new_weight = weight_phase_previous
                    product_treatment_phase_new.cost = new_cost
    
                    lot.update(weight: weight_phase_previous)
                
                    begin 
                        lot_phase_previous = ProductTreatmentPhase.find_by(id: product_treatment_phase_new.product_treatment_phase_id).product_treatment_phases.where("phase_id = ? and lot_id is not null",product_treatment_phase_new.phase_id).last.lot || nil
                    rescue
                        lot_phase_previous = nil 
                    end 

                    if lot_phase_previous.nil?
                        lot_new = Lot.create(cost: new_cost, weight: product_treatment_phase_new.weight, waste: 0.0, available: 0.0)
                        product_treatment_phase_new.lot_id = lot_new.id
                    else
                        product_treatment_phase_new.lot_id = lot_phase_previous.id
                        cost_previous_lot = (lot_phase_previous.cost * lot_phase_previous.weight) 
                        cost_new_lot = ( product_treatment_phase_new.cost * product_treatment_phase_new.weight )   
                        lot_phase_previous.cost = ( cost_previous_lot + cost_new_lot ) / ( lot_phase_previous.weight + product_treatment_phase_new.weight )
                        lot_phase_previous.cost
                        Lot.find_by(id: lot_phase_previous.id).update(weight: lot_phase_previous.weight + product_treatment_phase_new.weight,cost: lot_phase_previous.cost )
                    end  
                else  
                    render json: { message: "El peso ingresado es mayor al del inventario" }
                end
            end

            #Guardar Fase 
            if product_treatment_phase_new.save 
                render json: product_treatment_phase_new, status: :created, location: product_treatment_phase_new
            else
                render json: product_treatment_phase_new.errors, status: :unprocessable_entity
            end  
        end # --->>> closed transaction 
    else
        render json: { message: "No hay esa cantidad disponible en el inventario" }
    end #--->>>Closed invetary
end #--- >>> Closed method



# POST /classification_product_treatment_phase_params
def classification

    classification = classification_product_treatment_phase_params
    weight_products = classification[:classification].pluck(:weight).reduce(:+)
    inventary_initial = classification[:weight] 
    inventary = classification[:weight] 

    ProductTreatmentPhase.transaction do 
        
        lot_previous = Lot.joins(:product_treatment_phases).where(product_treatment_phases: { product_id: classification[:product_id], phase_id: classification[:phase_id] }).last

        if !classification[:weight_inventary].nil? && !lot_previous.nil?
            inventary_initial = classification[:weight_inventary]
            inventary = lot_previous[:weight]
            classification[:weight] = classification[:weight_inventary]
            classification[:cost] =  ( lot_previous[:cost] * classification[:weight] )
            lot_previous[:weight] =  ( lot_previous[:weight] - classification[:weight_inventary] )    
        end 

        classification[:weight] ||= 0
        
        if inventary_initial <= inventary
            if weight_products <= inventary_initial 

                cost_kilo = ( classification[:cost] + classification[:cost_treatments] ) / classification[:weight]

                product_treatment_phase = ProductTreatmentPhase.new(
                cost: cost_kilo,
                weight: classification[:weight] - weight_products,
                phase_id: classification[:phase_id],
                product_treatment_phase_id: nil,
                lot_id: nil, 
                product_id: classification[:product_id]                      
                )

                if lot_previous.nil?
                    lot_previous = Lot.create(cost: cost_kilo, weight: classification[:weight] - weight_products)
                else 
                    new_cost = ( ( (lot_previous.cost * lot_previous.weight) + (cost_kilo * (classification[:weight] - weight_products ) ) ) / (lot_previous.weight + ( classification[:weight] - weight_products ) ) )
                    new_weight = (lot_previous.weight + product_treatment_phase.weight) 
                    
                    new_cost = new_cost.nil? || new_cost.nan?  ? 0 : new_cost 
                    
                    lot_previous.update(cost: new_cost,weight: new_weight)  
                end 

                product_treatment_phase.lot_id = lot_previous.id

                Quantity.create(cost: (cost_kilo * product_treatment_phase.weight), weight: product_treatment_phase.weight, weight_initial: classification[:weight], product_id: product_treatment_phase.product_id, lot_id: lot_previous.id) if classification[:weight_inventary].nil?   
                
                if product_treatment_phase.save
                    treatment = Treatment.where("name LIKE ?","%#{classification[:name_treatments]}%").last
                    if treatment.nil? or treatment == []
                        treatment = Treatment.create(name: classification[:name_treatments])
                    end
                    ProductTreatment.create( cost: classification[:cost_treatments], weight: classification[:weight],treatment_id: treatment.id , product_treatment_phase_id: product_treatment_phase.id )
                    unless classification[:classification].nil? 
                        classification[:classification].each do |classification|
                            lot_previous_classification = Lot.joins(:product_treatment_phases).where(product_treatment_phases: { product_id: classification[:product_id], phase_id: classification[:phase_id] }).last
                            if lot_previous_classification.nil?
                                lot_previous_classification = Lot.create(cost: cost_kilo, weight: classification[:weight])
                            else
                                new_cost_classification = (  ( (lot_previous_classification.cost * lot_previous_classification.weight) + (cost_kilo * classification[:weight]) ) / (lot_previous_classification.weight + classification[:weight]) )
                                new_weight_classification = lot_previous_classification.weight + classification[:weight]
                                lot_previous_classification.update(cost: new_cost_classification, weight: new_weight_classification)
                            end 
                            ProductTreatmentPhase.create(cost: cost_kilo, weight: classification[:weight], phase_id: classification[:phase_id], product_treatment_phase_id: product_treatment_phase.id, lot_id: lot_previous_classification.id, product_id: classification[:product_id])
                            Quantity.create(cost: (cost_kilo * classification[:weight]), weight: classification[:weight], weight_initial: classification[:weight], product_id: classification[:product_id], lot_id: lot_previous_classification.id)     
                        end
                        render json: product_treatment_phase , each_serializer: ProductTreatmentPhaseClassificationSerializer 
                    end #--->>> closed unless
                else
                    render json: { message: "No se guardo la fase", errors: product_treatment_phase.errors }
                end     
            else
                render json: { message: "El peso de lo productos a clasificar es mayor al del inventario"}      
            end   
        else  
            render json: { message: "la cantidad a reclasificar es mayor a la del inventario"}    
        end
    end # --->>> closed transaction
end #--- >>> Closed method



    # #def summary_accesses
    # #    begin
    #         ActiveRecord::Base.transaction do
    #             # codigo de la transaccion
    #         end
    #     rescue Exception => e
    #         Rails.logger.debug("Excepción lanzada #{e.message}")
            
    #     end
    # end

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
        :phase_id_previous,
        :weight, 
        :phase_id, 
        :product_id,
        :product_treatment_phase_id,
        product_treatments_attributes: [ :cost, :weight, :waste, :treatment_id, :treatment_new_name ]
      )
    end

    def classification_product_treatment_phase_params
     { 
       weight_inventary: params[:weight_inventary],
       weight: params[:weight],
       cost: params[:cost],
       cost_treatments: params[:cost_treatments],
       name_treatments: params[:name_treatments],
       phase_id: params[:phase_id],
       product_id: params[:product_id],
       product_treatment_phase_id: params[:product_treatment_phase_id],
       classification: params[:classification]
    }
    end

end
