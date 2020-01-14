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
    
    Rails.logger.debug('--->>> entando al create <<<---')
    @product_treatment_phase = product_treatment_phase_params 
    Rails.logger.debug('--->>> 1 <<<---')              
    phase_id_previous = params[:phase_id_previous]
    Rails.logger.debug('--->>> 2 <<<---') 
    last_product_treatment_phase = ProductTreatmentPhase.last_by_product_per_phase(@product_treatment_phase[:product_id],phase_id_previous)
    Rails.logger.debug('--->>> 3 <<<---') 
    @product_treatment_phase[:product_treatment_phase_id] = last_product_treatment_phase.nil? ? nil : last_product_treatment_phase.id
    Rails.logger.debug('--->>> 4 <<<---') 
    inventary = Lot.by_product_treatment_phase(@product_treatment_phase[:product_treatment_phase_id])
    Rails.logger.debug('--->>> 5 <<<---') 
    if @product_treatment_phase[:weight] <= inventary.weight
        Rails.logger.debug('--->>> 6 <<<---') 
        treatments = Treatment.all
        Rails.logger.debug('--->>> 7 <<<---') 
        cost_treatments = 0
        Rails.logger.debug('--->>> 8 <<<---')
        ProductTreatmentPhase.transaction do 
            Rails.logger.debug('--->>> 9 <<<---')
            @product_treatment_phase[:product_treatments_attributes].each do |product_treatment|
                Rails.logger.debug('--->>> 10 <<<---')
                if product_treatment[:treatment_id].nil? 
                    Rails.logger.debug('--->>> 11 <<<---')
                    treatment = treatments.select{ |element| element.name==product_treatment[:treatment_new_name]}.last
                    Rails.logger.debug('--->>> 12 <<<---')
                    if treatment.nil?
                        Rails.logger.debug('--->>> 13 <<<---')
                        treatment = Treatment.create(name: product_treatment[:treatment_new_name] )
                        Rails.logger.debug('--->>> 14 <<<---')
                    end
                    Rails.logger.debug('--->>> 15 <<<---')
                    product_treatment[:treatment_id] = treatment.id
                    Rails.logger.debug('--->>> 16 <<<---')
                    cost_treatments = cost_treatments + product_treatment[:cost]
                end 
                Rails.logger.debug('--->>> 17 <<<---')
                cost_treatments = cost_treatments + product_treatment[:cost]
                Rails.logger.debug('--->>> 18 <<<---')
            end

            Rails.logger.debug('--->>> 19 <<<---')
            product_treatment_phase_new = ProductTreatmentPhase.new(
                weight: @product_treatment_phase[:weight], 
                phase_id: @product_treatment_phase[:phase_id],
                product_id: @product_treatment_phase[:product_id],
                product_treatment_phase_id: @product_treatment_phase[:product_treatment_phase_id] || nil,
                product_treatments_attributes: @product_treatment_phase[:product_treatments_attributes].map{ |phase| { "cost" => phase[:cost], "treatment_id" => phase[:treatment_id] } }
            )   
            Rails.logger.debug('--->>> 20 <<<---')    

            product_treatment_phase_new.cost = 0 
            Rails.logger.debug('--->>> 21 <<<---')  

            #validamos que tenga una face anterior 
            if !product_treatment_phase_new.product_treatment_phase_id.nil? 
                Rails.logger.debug('--->>> 22 <<<---')  
     
                lot = ProductTreatmentPhase.find(product_treatment_phase_new.product_treatment_phase_id).lot
                
                Rails.logger.debug('--->>> 23 <<<---')  

                cost_phase_previous = lot.cost
                Rails.logger.debug('--->>> 24 <<<---')
                weight_phase_previous = lot.weight
                Rails.logger.debug('--->>> 25 <<<---') 

                if product_treatment_phase_new.weight <= weight_phase_previous
                    Rails.logger.debug('--->>> 26 <<<---') 

                    product_treatment_phases = lot.product_treatment_phases.order(created_at: :asc).where("weight > 0")
                    Rails.logger.debug('--->>> 27 <<<---')

                    cost_phase_previous_with_treatments = ((( cost_phase_previous * product_treatment_phase_new.weight) + cost_treatments) / product_treatment_phase_new.weight )
                    Rails.logger.debug('--->>> 28 <<<---')
                    weight_phase_previous = weight_phase_previous - product_treatment_phase_new.weight
                    Rails.logger.debug('--->>> 29 <<<---') 
                    new_cost = cost_phase_previous_with_treatments
                    Rails.logger.debug('--->>> 30 <<<---') 
                    new_weight = weight_phase_previous
                    Rails.logger.debug('--->>> 31 <<<---')  
                    product_treatment_phase_new.cost = new_cost
                    Rails.logger.debug('--->>> 32 <<<---')
                    lot.update(weight: weight_phase_previous)
                    Rails.logger.debug('--->>> 33 <<<---')
                    begin 
                        Rails.logger.debug('--->>> 34 <<<---')
                        lot_phase_previous = ProductTreatmentPhase.find_by(id: product_treatment_phase_new.product_treatment_phase_id).product_treatment_phases.where("phase_id = ? and lot_id is not null",product_treatment_phase_new.phase_id).last.lot || nil
                        Rails.logger.debug('--->>> 35 <<<---')
                    rescue
                        Rails.logger.debug('--->>> 36 <<<---')
                        lot_phase_previous = nil 
                        Rails.logger.debug('--->>> 37 <<<---')
                    end 
                    Rails.logger.debug('--->>> 38 <<<---')

                    if lot_phase_previous.nil?
                        Rails.logger.debug('--->>> 39 <<<---')
                        lot_new = Lot.create(cost: new_cost, weight: product_treatment_phase_new.weight, waste: 0.0, available: 0.0)
                        Rails.logger.debug('--->>> 40 <<<---')
                        product_treatment_phase_new.lot_id = lot_new.id
                        Rails.logger.debug('--->>> 41 <<<---')
                    else
                        Rails.logger.debug('--->>> 42 <<<---')
                        product_treatment_phase_new.lot_id = lot_phase_previous.id
                        Rails.logger.debug('--->>> 43 <<<---')
                        cost_previous_lot = (lot_phase_previous.cost * lot_phase_previous.weight) 
                        Rails.logger.debug('--->>> 44 <<<---')
                        cost_new_lot = ( product_treatment_phase_new.cost * product_treatment_phase_new.weight )  
                        Rails.logger.debug('--->>> 45 <<<---')
                        lot_phase_previous.cost = ( cost_previous_lot + cost_new_lot ) / ( lot_phase_previous.weight + product_treatment_phase_new.weight )
                        Rails.logger.debug('--->>> 46 <<<---')
                        lot_phase_previous.cost
                        Rails.logger.debug('--->>> 47 <<<---')
                        Lot.find_by(id: lot_phase_previous.id).update(weight: lot_phase_previous.weight + product_treatment_phase_new.weight,cost: lot_phase_previous.cost )
                        Rails.logger.debug('--->>> 48 <<<---')
                    end  
                else  
                    Rails.logger.debug('--->>> 49 <<<---')
                    render json: { message: "El peso ingresado es mayor al del inventario" }
                    Rails.logger.debug('--->>> 50 <<<---')
                end
            end

            #Guardar Fase 
            Rails.logger.debug('--->>> 51 <<<---')
            if product_treatment_phase_new.save 
                Rails.logger.debug('--->>> 52 <<<---')
                ### pool
                if product_treatment_phase_new.phase_id == 4 
                    Rails.logger.debug('--->>> 53 <<<---')    
                    product_treatment_phase_new_pool = ProductTreatmentPhase.new(
                        cost: product_treatment_phase_new[:cost], 
                        weight: product_treatment_phase_new[:weight], 
                        phase_id: product_treatment_phase_new[:phase_id],
                        product_id: product_treatment_phase_new[:product_id],
                        product_treatment_phase_id: nil    
                    )  
                    Rails.logger.debug('--->>> 54 <<<---')      
                    
                    product_treatment_phase_new_pool.id = nil
                    Rails.logger.debug('--->>> 55 <<<---')  
                    product = Product.where("product_id = ? or id = ? ",product_treatment_phase_new_pool.product_id,product_treatment_phase_new_pool.product_id).uniq
                    Rails.logger.debug('--->>> 56 <<<---')
                    products_product_id = product.map{ |product| product.product_id }
                    Rails.logger.debug('--->>> 57 <<<---')
                    products_id = product.map{ |product| product.id }
                    Rails.logger.debug('--->>> 58 <<<---')
                    products = ( products_product_id + products_id ) 
                    Rails.logger.debug('--->>> 59 <<<---')
                    lot_pool =  Lot.joins(:product_treatment_phases).where("product_id in ( ? ) and phase_id = 5 ",products)
                    Rails.logger.debug('--->>> 60 <<<---')
                    product_treatment_phase_new_pool.product_treatment_phase_id = product_treatment_phase_new_pool.id
                    Rails.logger.debug('--->>> 61 <<<---')
                    product_treatment_phase_new_pool.phase_id = 5
                    Rails.logger.debug('--->>> 62 <<<---')
                    if lot_pool.nil? || lot_pool.empty?
                        Rails.logger.debug('--->>> 63 <<<---')
                        lot_new = Lot.new(cost: product_treatment_phase_new_pool.cost, weight: product_treatment_phase_new_pool.weight)
                        Rails.logger.debug('--->>> 64 <<<---')
                        if lot_new.save 
                            Rails.logger.debug('--->>> 65 <<<---')
                            product_treatment_phase_new_pool.lot_id = lot_new.id
                            Rails.logger.debug('--->>> 66 <<<---')
                            product_treatment_phase_new_pool.save
                            Rails.logger.debug('--->>> 67 <<<---') 
                        end
                    else
                        Rails.logger.debug('--->>> 68 <<<---')
                        lot_pool = lot_pool.last
                        Rails.logger.debug('--->>> 69 <<<---')
                        product_treatment_phase_new_pool.lot_id = lot_pool.id
                        Rails.logger.debug('--->>> 70 <<<---')
                        cost_previous_lot_pool = (lot_pool.cost * lot_pool.weight) 
                        Rails.logger.debug('--->>> 71 <<<---')
                        cost_new_lot_pool = ( product_treatment_phase_new_pool.cost * product_treatment_phase_new_pool.weight )   
                        Rails.logger.debug('--->>> 72 <<<---')
                        lot_pool.cost = ( cost_previous_lot_pool + cost_new_lot_pool ) / ( lot_pool.weight + product_treatment_phase_new_pool.weight )
                        Rails.logger.debug('--->>> 73 <<<---')
                        lot_pool.update(weight: lot_pool.weight + product_treatment_phase_new_pool.weight,cost: lot_pool.cost ) 
                        Rails.logger.debug('--->>> 74 <<<---') 
                        product_treatment_phase_new_pool.save  
                        Rails.logger.debug('--->>> 75 <<<---')
                    end   
                    Rails.logger.debug('--->>> 76 <<<---')
                end 
                Rails.logger.debug('--->>> 77 <<<---')
                render json: product_treatment_phase_new, status: :created, location: product_treatment_phase_new
                Rails.logger.debug('--->>> 78 <<<---')
            else
                Rails.logger.debug('--->>> 79 <<<---')
                render json: product_treatment_phase_new.errors, status: :unprocessable_entity
                Rails.logger.debug('--->>> 80 <<<---')
            end  
            Rails.logger.debug('--->>> 81 <<<---')
        end # --->>> closed transaction 
        Rails.logger.debug('--->>> 82 <<<---')
    else
        Rails.logger.debug('--->>> 83 <<<---')
        render json: { message: "No hay esa cantidad disponible en el inventario" }
        Rails.logger.debug('--->>> 84 <<<---')
    end #--->>>Closed invetary
    Rails.logger.debug('--->>> 85 <<<---')
end #--- >>> Closed method



# name_treatments
# cost_treatments
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

                cost_treatments = classification[:treatments].pluck(:cost_treatment).reduce(:+)
                ### cost_kilo = ( classification[:cost] + classification[:cost_treatments] ) / classification[:weight]
               
                cost_kilo = ( classification[:cost] + cost_treatments ) / classification[:weight]   

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
                
                    classification[:treatments].each do |treat|
                        if treat[:treatment_id].nil?  
                            treatment = Treatment.where("name LIKE ?","%#{treat[:name_treatment]}%").last
                            if treatment.nil? or treatment == []
                                treatment = Treatment.create(name: treat[:name_treatment])
                            end
                        else
                            treatment = Treatment.find_by(id: treat[:treatment_id])           
                        end

                        ### ProductTreatment.create( cost: classification[:cost_treatments], weight: classification[:weight],treatment_id: treatment.id , product_treatment_phase_id: product_treatment_phase.id )
                        ProductTreatment.create( cost: treat[:cost_treatment], weight: classification[:weight],treatment_id: treatment.id , product_treatment_phase_id: product_treatment_phase.id )
                    end  

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
                            product_treatment_phase_new = ProductTreatmentPhase.new(cost: cost_kilo, weight: classification[:weight], phase_id: classification[:phase_id], product_treatment_phase_id: product_treatment_phase.id, lot_id: lot_previous_classification.id, product_id: classification[:product_id])
                            Quantity.create(cost: (cost_kilo * classification[:weight]), weight: classification[:weight], weight_initial: classification[:weight], product_id: classification[:product_id], lot_id: lot_previous_classification.id)     

                            ### pool
                            if product_treatment_phase_new.save
                                if product_treatment_phase_new.phase_id == 4 
                        
                                    product_treatment_phase_new_pool = ProductTreatmentPhase.new(
                                        cost: product_treatment_phase_new[:cost], 
                                        weight: product_treatment_phase_new[:weight], 
                                        phase_id: product_treatment_phase_new[:phase_id],
                                        product_id: product_treatment_phase_new[:product_id],
                                        product_treatment_phase_id: nil    
                                    )       
                                    
                                    product_treatment_phase_new_pool.id = nil
                                    product = Product.where("product_id = ? or id = ? ",product_treatment_phase_new_pool.product_id,product_treatment_phase_new_pool.product_id).uniq
                                    products_product_id = product.map{ |product| product.product_id }
                                    products_id = product.map{ |product| product.id }
                                    products = ( products_product_id + products_id ) 
                                    lot_pool =  Lot.joins(:product_treatment_phases).where("product_id in ( ? ) and phase_id = 5 ",products)
                                    product_treatment_phase_new_pool.product_treatment_phase_id = product_treatment_phase_new_pool.id
                                    product_treatment_phase_new_pool.phase_id = 5
                                    if lot_pool.nil? || lot_pool.empty?
                                        lot_new = Lot.new(cost: product_treatment_phase_new_pool.cost, weight: product_treatment_phase_new_pool.weight)
                                        if lot_new.save 
                                            product_treatment_phase_new_pool.lot_id = lot_new.id
                                            product_treatment_phase_new_pool.save  
                                        end
                                    else
                                        lot_pool = lot_pool.last
                                        product_treatment_phase_new_pool.lot_id = lot_pool.id
                                        cost_previous_lot_pool = (lot_pool.cost * lot_pool.weight) 
                                        cost_new_lot_pool = ( product_treatment_phase_new_pool.cost * product_treatment_phase_new_pool.weight )   
                                        lot_pool.cost = ( cost_previous_lot_pool + cost_new_lot_pool ) / ( lot_pool.weight + product_treatment_phase_new_pool.weight )
                                        lot_pool.update(weight: lot_pool.weight + product_treatment_phase_new_pool.weight,cost: lot_pool.cost )  
                                        product_treatment_phase_new_pool.save  
                                    end   
                                end 
                            end
                            ### closed pool

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
        product_treatments_attributes: [ :cost, :weight, :waste, :treatment_id, :treatment_new_name, :minimal_cost, :maximum_cost ]
      )
    end

    def classification_product_treatment_phase_params
     { 
       weight_inventary: params[:weight_inventary],
       weight: params[:weight],
       cost: params[:cost],
       treatments: params[:treatments],
       phase_id: params[:phase_id],
       product_id: params[:product_id],
       product_treatment_phase_id: params[:product_treatment_phase_id],
       classification: params[:classification]
    }
    end 


    # def classification_product_treatment_phase_params
    #     { 
    #       weight_inventary: params[:weight_inventary],
    #       weight: params[:weight],
    #       cost: params[:cost],
    #       cost_treatments: params[:cost_treatments],
    #       name_treatments: params[:name_treatments],
    #       phase_id: params[:phase_id],
    #       product_id: params[:product_id],
    #       product_treatment_phase_id: params[:product_treatment_phase_id],
    #       classification: params[:classification]
    #     }
    # end

end
