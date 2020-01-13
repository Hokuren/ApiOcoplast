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
    
    puts '--->>> entando al create <<<---'
    @product_treatment_phase = product_treatment_phase_params 
    puts '--->>> 1 <<<---'                
    phase_id_previous = params[:phase_id_previous]
    puts '--->>> 2 <<<---'   
    last_product_treatment_phase = ProductTreatmentPhase.last_by_product_per_phase(@product_treatment_phase[:product_id],phase_id_previous)
    puts '--->>> 3 <<<---'
    @product_treatment_phase[:product_treatment_phase_id] = last_product_treatment_phase.nil? ? nil : last_product_treatment_phase.id
    puts '--->>> 4 <<<---'
    inventary = Lot.by_product_treatment_phase(@product_treatment_phase[:product_treatment_phase_id])
    puts '--->>> 5 <<<---'
    if @product_treatment_phase[:weight] <= inventary.weight
        puts '--->>> 6 <<<---'
        treatments = Treatment.all
        puts '--->>> 7 <<<---'
        cost_treatments = 0
        puts '--->>> 8 <<<---'
        ProductTreatmentPhase.transaction do 
            puts '--->>> 9 <<<---'
            @product_treatment_phase[:product_treatments_attributes].each do |product_treatment|
                puts '--->>> 10 <<<---'
                if product_treatment[:treatment_id].nil? 
                    puts '--->>> 11 <<<---'
                    treatment = treatments.select{ |element| element.name==product_treatment[:treatment_new_name]}.last
                    puts '--->>> 12 <<<---'
                    if treatment.nil?
                        puts '--->>> 13 <<<---'
                        treatment = Treatment.create(name: product_treatment[:treatment_new_name] )
                        puts '--->>> 14 <<<---'
                    end
                    puts '--->>> 15 <<<---'
                    product_treatment[:treatment_id] = treatment.id
                    puts '--->>> 16 <<<---'
                    #cost_treatments = cost_treatments + product_treatment[:cost]
                end 
                puts '--->>> 17 <<<---'
                cost_treatments = cost_treatments + product_treatment[:cost]
                puts '--->>> 18 <<<---'
            end

            puts '--->>> 19 <<<---'
            product_treatment_phase_new = ProductTreatmentPhase.new(
                weight: @product_treatment_phase[:weight], 
                phase_id: @product_treatment_phase[:phase_id],
                product_id: @product_treatment_phase[:product_id],
                product_treatment_phase_id: @product_treatment_phase[:product_treatment_phase_id] || nil,
                product_treatments_attributes: @product_treatment_phase[:product_treatments_attributes].map{ |phase| { "cost" => phase[:cost], "treatment_id" => phase[:treatment_id] } }
            )   
            puts '--->>> 20 <<<---'    

            product_treatment_phase_new.cost = 0 
            puts '--->>> 21 <<<---'   

            #validamos que tenga una face anterior 
            if !product_treatment_phase_new.product_treatment_phase_id.nil? 
                puts '--->>> 22 <<<---'   
     
                lot = ProductTreatmentPhase.find(product_treatment_phase_new.product_treatment_phase_id).lot
                
                puts '--->>> 23 <<<---'  

                cost_phase_previous = lot.cost
                puts '--->>> 24 <<<---' 
                weight_phase_previous = lot.weight
                puts '--->>> 25 <<<---' 

                if product_treatment_phase_new.weight <= weight_phase_previous
                    puts '--->>> 26 <<<---' 

                    product_treatment_phases = lot.product_treatment_phases.order(created_at: :asc).where("weight > 0")
                    puts '--->>> 27 <<<---' 

                    cost_phase_previous_with_treatments = ((( cost_phase_previous * product_treatment_phase_new.weight) + cost_treatments) / product_treatment_phase_new.weight )
                    puts '--->>> 28 <<<---' 
                    weight_phase_previous = weight_phase_previous - product_treatment_phase_new.weight
                    puts '--->>> 29 <<<---' 
                    new_cost = cost_phase_previous_with_treatments
                    puts '--->>> 30 <<<---' 
                    new_weight = weight_phase_previous
                    puts '--->>> 31 <<<---' 
                    product_treatment_phase_new.cost = new_cost
                    puts '--->>> 32 <<<---' 
                    lot.update(weight: weight_phase_previous)
                    puts '--->>> 33 <<<---'
                    begin 
                        puts '--->>> 34 <<<---'
                        lot_phase_previous = ProductTreatmentPhase.find_by(id: product_treatment_phase_new.product_treatment_phase_id).product_treatment_phases.where("phase_id = ? and lot_id is not null",product_treatment_phase_new.phase_id).last.lot || nil
                        puts '--->>> 35 <<<---'
                    rescue
                        puts '--->>> 36 <<<---'
                        lot_phase_previous = nil 
                        puts '--->>> 37 <<<---'
                    end 
                    puts '--->>> 38 <<<---'

                    if lot_phase_previous.nil?
                        puts '--->>> 39 <<<---'
                        lot_new = Lot.create(cost: new_cost, weight: product_treatment_phase_new.weight, waste: 0.0, available: 0.0)
                        puts '--->>> 40 <<<---'
                        product_treatment_phase_new.lot_id = lot_new.id
                        puts '--->>> 41 <<<---'
                    else
                        puts '--->>> 42 <<<---'
                        product_treatment_phase_new.lot_id = lot_phase_previous.id
                        puts '--->>> 43 <<<---'
                        cost_previous_lot = (lot_phase_previous.cost * lot_phase_previous.weight) 
                        puts '--->>> 44 <<<---'
                        cost_new_lot = ( product_treatment_phase_new.cost * product_treatment_phase_new.weight )  
                        puts '--->>> 45 <<<---' 
                        lot_phase_previous.cost = ( cost_previous_lot + cost_new_lot ) / ( lot_phase_previous.weight + product_treatment_phase_new.weight )
                        puts '--->>> 46 <<<---' 
                        lot_phase_previous.cost
                        puts '--->>> 47 <<<---'
                        Lot.find_by(id: lot_phase_previous.id).update(weight: lot_phase_previous.weight + product_treatment_phase_new.weight,cost: lot_phase_previous.cost )
                        puts '--->>> 48 <<<---'
                    end  
                else  
                    puts '--->>> 49 <<<---'
                    render json: { message: "El peso ingresado es mayor al del inventario" }
                    puts '--->>> 50 <<<---'
                end
            end

            #Guardar Fase 
            puts '--->>> 51 <<<---'
            if product_treatment_phase_new.save 
                puts '--->>> 52 <<<---'
                ### pool
                if product_treatment_phase_new.phase_id == 4 
                    puts '--->>> 53 <<<---'     
                    product_treatment_phase_new_pool = ProductTreatmentPhase.new(
                        cost: product_treatment_phase_new[:cost], 
                        weight: product_treatment_phase_new[:weight], 
                        phase_id: product_treatment_phase_new[:phase_id],
                        product_id: product_treatment_phase_new[:product_id],
                        product_treatment_phase_id: nil    
                    )  
                    puts '--->>> 54 <<<---'       
                    
                    product_treatment_phase_new_pool.id = nil
                    puts '--->>> 55 <<<---'   
                    product = Product.where("product_id = ? or id = ? ",product_treatment_phase_new_pool.product_id,product_treatment_phase_new_pool.product_id).uniq
                    puts '--->>> 56 <<<---'
                    products_product_id = product.map{ |product| product.product_id }
                    puts '--->>> 57 <<<---'
                    products_id = product.map{ |product| product.id }
                    puts '--->>> 58 <<<---'
                    products = ( products_product_id + products_id ) 
                    puts '--->>> 59 <<<---'
                    lot_pool =  Lot.joins(:product_treatment_phases).where("product_id in ( ? ) and phase_id = 5 ",products)
                    puts '--->>> 60 <<<---'
                    product_treatment_phase_new_pool.product_treatment_phase_id = product_treatment_phase_new_pool.id
                    puts '--->>> 61 <<<---'
                    product_treatment_phase_new_pool.phase_id = 5
                    puts '--->>> 62 <<<---'
                    if lot_pool.nil? || lot_pool.empty?
                        puts '--->>> 63 <<<---'
                        lot_new = Lot.new(cost: product_treatment_phase_new_pool.cost, weight: product_treatment_phase_new_pool.weight)
                        puts '--->>> 64 <<<---'
                        if lot_new.save 
                            puts '--->>> 65 <<<---'
                            product_treatment_phase_new_pool.lot_id = lot_new.id
                            puts '--->>> 66 <<<---'
                            product_treatment_phase_new_pool.save
                            puts '--->>> 67 <<<---'  
                        end
                    else
                        puts '--->>> 68 <<<---'
                        lot_pool = lot_pool.last
                        puts '--->>> 69 <<<---'
                        product_treatment_phase_new_pool.lot_id = lot_pool.id
                        puts '--->>> 70 <<<---'
                        cost_previous_lot_pool = (lot_pool.cost * lot_pool.weight) 
                        puts '--->>> 71 <<<---'
                        cost_new_lot_pool = ( product_treatment_phase_new_pool.cost * product_treatment_phase_new_pool.weight )   
                        puts '--->>> 72 <<<---'
                        lot_pool.cost = ( cost_previous_lot_pool + cost_new_lot_pool ) / ( lot_pool.weight + product_treatment_phase_new_pool.weight )
                        puts '--->>> 73 <<<---'
                        lot_pool.update(weight: lot_pool.weight + product_treatment_phase_new_pool.weight,cost: lot_pool.cost ) 
                        puts '--->>> 74 <<<---' 
                        product_treatment_phase_new_pool.save  
                        puts '--->>> 75 <<<---'
                    end   
                    puts '--->>> 76 <<<---'
                end 
                puts '--->>> 77 <<<---'
                render json: product_treatment_phase_new, status: :created, location: product_treatment_phase_new
                puts '--->>> 78 <<<---'
            else
                puts '--->>> 79 <<<---'
                render json: product_treatment_phase_new.errors, status: :unprocessable_entity
                puts '--->>> 80 <<<---'
            end  
            puts '--->>> 81 <<<---'
        end # --->>> closed transaction 
        puts '--->>> 82 <<<---'
    else
        puts '--->>> 83 <<<---'
        render json: { message: "No hay esa cantidad disponible en el inventario" }
        puts '--->>> 84 <<<---'
    end #--->>>Closed invetary
    puts '--->>> 85 <<<---'
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
