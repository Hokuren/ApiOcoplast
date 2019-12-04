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

    inventary = Lot.joins(:product_treatment_phases).where(product_treatment_phases: { id: @product_treatment_phase[:product_treatment_phase_id] }).last

    if @product_treatment_phase[:weight] <= inventary.weight

        treatments = Treatment.all
        cost_treatments = 0
        
        ProductTreatmentPhase.transaction do 

            @product_treatment_phase[:product_treatments_attributes].each do |product_treatment|
                if product_treatment[:treatment_id].nil? 
                    puts "--->>>if no tiene Tratamiento<<<---"
                    treatment = treatments.where("name LIKE ?", "%#{product_treatment[:treatment_new_name]}%").last
                    if treatment.nil?
                        puts "--->>>if se crea Tratamiento<<<---"
                        treatment = Treatment.create(name: product_treatment[:treatment_new_name] )
                    end
                    product_treatment[:treatment_id] = treatment.id
                    cost_treatments = cost_treatments + product_treatment[:cost]
                end 
            end

            #binding.pry 
            product_treatment_phase_new = ProductTreatmentPhase.new(
                weight: @product_treatment_phase[:weight], 
                phase_id: @product_treatment_phase[:phase_id],
                product_id: @product_treatment_phase[:product_id],
                product_treatment_phase_id: @product_treatment_phase[:product_treatment_phase_id] || nil,
                product_treatments_attributes: @product_treatment_phase[:product_treatments_attributes].map{ |phase| { "cost" => phase[:cost], "treatment_id" => phase[:treatment_id] } }
            )
        
            ### --- >>> inicio 
            product_treatment_phase_new.cost = 0 

            #validamos que tenga una face anterior 
            if !product_treatment_phase_new.product_treatment_phase_id.nil? 
                puts "--->>>Primer if<<<---"
                begin
                    #lotClean = ProductTreatmentPhase.where(id: product_treatment_phase_new.product_treatment_phase_id, product_treatment_phase_id: nil).last.lots.where(weight: 0)
                    lotClean = Lot.where(weight: 0).last.product_treatment_phases.where(id: product_treatment_phase_new.product_treatment_phase_id, product_treatment_phase_id: nil)
                rescue
                    lotClean = 0 
                end
                #validamos que el lote de la face anterior este seteado en 0
                if lotClean.nil? 
                    puts "--->>> Entre al if de lotClean <<<---"
                    lot_previous = ProductTreatmentPhase.find_by(id: product_treatment_phase_new.product_treatment_phase_id).lots
                    product_treatment_phase_new.cost = lot_previous.last.cost
                    product_treatment_phase_new.weight = lot_previous.last.weight
                    Lot.create(cost: product_treatment_phase_new.cost, weight: product_treatment_phase_new.weight, waste: 0.0, available: 0.0, product_treatment_phase_id: product_treatment_phase_new.id)        
                else
                    puts "--->>> Entro al ElSE de lotClean <<<---"
                    #bucamos el lote de la face anterior 
                    lot = ProductTreatmentPhase.find(product_treatment_phase_new.product_treatment_phase_id).lot
                    if !product_treatment_phase_new.product_treatment_phase_id.nil? and product_treatment_phase_new.phase_id == 2 and lot.cost == 0
                        lot_cost = Lot.find_by(id: lot.id).quantities.sum(:cost) 
                        lot_weight = Lot.find_by(id: lot.id).quantities.sum(:weight) 
                        if product_treatment_phase_new.weight <= lot_weight  
                        
                                puts "--->>>Entro al if de validacion del peso actual es menor o igual al de la fase anterior<<<---"
                                previous_cost_kilo_phase = ( lot_cost / lot_weight )
                                previous_weight = lot_weight - product_treatment_phase_new.weight

                                new_weight = product_treatment_phase_new.weight
                                new_cost = ( ( (previous_cost_kilo_phase * new_weight ) + cost_treatments ) / new_weight )
                                product_treatment_phase_new.cost = new_cost

                                #acutaliza el cost y weight la fase 0 y el lote 0
                                ProductTreatmentPhase.find_by(id: product_treatment_phase_new.product_treatment_phase_id).update(cost: previous_cost_kilo_phase, weight: previous_weight)
                                ProductTreatmentPhase.find_by(id: product_treatment_phase_new.product_treatment_phase_id).lot.update(cost: previous_cost_kilo_phase, weight: previous_weight)
                                lot_new = Lot.new(cost: new_cost, weight: product_treatment_phase_new.weight, waste: 0.0, available: 0.0)
        
                            if lot_new.save
                                product_treatment_phase_new.lot_id = lot_new.id
                            end
                        else  
                            render json: { message: "El peso ingresado es mayor al del inventario" }
                        end

                    else 
                        puts "--->>> No soy primera face <<<---"
                        cost_phase_previous = lot.cost
                        weight_phase_previous = lot.weight
                        
                        if product_treatment_phase_new.weight <= weight_phase_previous
                            #costo de la face anterior con los tratamientos 
                            product_treatment_phases = ProductTreatmentPhase.find(product_treatment_phase_new.product_treatment_phase_id).lot.product_treatment_phases.order(created_at: :asc).where("weight > 0")
                            #product_treatment_phases = ProductTreatmentPhase.find(product_treatment_phase_new.product_treatment_phase_id).lot.product_treatment_phases.order(created_at: :asc)
                            weight_to_remove = product_treatment_phase_new.weight
                            weight_to_remove_quantity = weight_to_remove
                            temp = weight_to_remove_quantity

                            #le quitamos el peso que necesitamos a la fase anterior 
                            product_treatment_phases.each do |product_treatment_phase|
                                
                                 weight = weight_to_remove >= product_treatment_phase.weight ? 0  : product_treatment_phase.weight - weight_to_remove
                                 ProductTreatmentPhase.find_by(id: product_treatment_phase.id).update(weight: weight)  
                                
                                 if product_treatment_phase.weight >= temp
                                     break
                                 end
                    
                                Quantity.find_by(id: product_treatment_phase.id).update(weight: weight)

                        
                            end # --->>> closed each
                            
                            cost_phase_previous_with_treatments = ((( cost_phase_previous * product_treatment_phase_new.weight) + cost_treatments) / product_treatment_phase_new.weight )
                            weight_phase_previous = weight_phase_previous - product_treatment_phase_new.weight
                    
                            new_cost = cost_phase_previous_with_treatments
                            new_weight = weight_phase_previous
                            product_treatment_phase_new.cost = new_cost
                
                            #acutaliza el (peso)weight la fase anterior y el lote 
                            #ProductTreatmentPhase.find_by(id: product_treatment_phase_new.product_treatment_phase_id).update(weight: weight_phase_previous)
                            ProductTreatmentPhase.find_by(id: product_treatment_phase_new.product_treatment_phase_id).lot.update(weight: weight_phase_previous)

                            #si mi phase anterior tiene un lote en mi misma face actual
                            #lot_phase_previous = ProductTreatmentPhase.find_by(id: product_treatment_phase_new.product_treatment_phase_id).product_treatment_phases.where("phase_id = ? and lot_id is not null",product_treatment_phase_new.phase_id).last
                            
                            begin 
                                lot_phase_previous = ProductTreatmentPhase.find_by(id: product_treatment_phase_new.product_treatment_phase_id).product_treatment_phases.where("phase_id = ? and lot_id is not null",product_treatment_phase_new.phase_id).last.lot
                                #lot_phase_previous = Lot.joins(:product_treatment_phases).where(product_treatment_phases: { id: product_treatment_phase_new.product_treatment_phase_id }).last
                            rescue
                                lot_phase_previous = nil 
                            end

                            if lot_phase_previous.nil? 
                                puts "--->>>NO hay una lote posterior de las phase anteior<<<---"
                                lot_new = Lot.create(cost: new_cost, weight: product_treatment_phase_new.weight, waste: 0.0, available: 0.0)
                                product_treatment_phase_new.lot_id = lot_new.id
                            else
                                puts "--->>>La face anterioir tiene faces con un lote en la face actual<<<---" 
                                #product_treatment_phase_new.lot_id = lot_phase_previous.lot_id
                                product_treatment_phase_new.lot_id = lot_phase_previous.id
                                cost_previous_lot = (lot_phase_previous.cost * lot_phase_previous.weight) 
                                cost_new_lot = ( product_treatment_phase_new.cost * product_treatment_phase_new.weight )   
                                lot_phase_previous.cost = ( cost_previous_lot + cost_new_lot ) / ( lot_phase_previous.weight + product_treatment_phase_new.weight )
                                ###binding.pry
                                lot_phase_previous.cost
                                ###binding.pry
                                Lot.find_by(id: lot_phase_previous.id).update(weight: lot_phase_previous.weight + product_treatment_phase_new.weight,cost: lot_phase_previous.cost )
                            end  
                        else  
                            render json: { message: "El peso ingresado es mayor al del inventario" }
                        end
                    end 
                end
            end

            #Guardar Fase 
        
            if product_treatment_phase_new.save 
                if product_treatment_phase_new.phase_id == 2
                    quantities = Quantity.joins(lot: [:product_treatment_phases]).where(product_treatment_phases: { id: product_treatment_phase_new.product_treatment_phase_id })
                    weight_to_remove_quantity = product_treatment_phase_new.weight
                    temp2 = weight_to_remove_quantity
                    quantities.each do |quantity|
                        if weight_to_remove >= quantity.weight 
                            weight_quantity  = 0 
                            weight_to_remove = weight_to_remove - quantity.weight 
                        else
                            weight_quantity = quantity.weight - weight_to_remove
                            
                        end
                        Quantity.find_by(id: quantity.id).update(weight: weight_quantity)

                        if quantity.weight >= temp2
                            break
                        end
                    end #---closed each 
                end
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

        weight_products = 0
        classification[:classification].each do |c|
            weight_products = weight_products + c[:weight]    
        end

        if weight_products <= classification[:weight]
            cost_kilo = ( classification[:cost] + classification[:cost_treatments] ) / classification[:weight]
            product_treatment_phase = ProductTreatmentPhase.new(
            cost: cost_kilo,
            weight: classification[:weight] - weight_products,
            phase_id: classification[:phase_id],
            product_treatment_phase_id: nil,
            lot_id: nil, 
            product_id: classification[:product_id]                      
            )

            lot_previous = Lot.joins(:product_treatment_phases).where(product_treatment_phases: { product_id: classification[:product_id], phase_id: classification[:phase_id] }).last

            if lot_previous.nil?
                lot_previous = Lot.create(cost: cost_kilo, weight: classification[:weight] - weight_products)
            else 
                new_cost = ( ( (lot_previous.cost * lot_previous.weight) + (cost_kilo * classification[:weight]) ) / (lot_previous.weight + classification[:weight]) )
                new_weight = (lot_previous.weight + product_treatment_phase.weight) 
                lot_previous.update(cost: new_cost, weight: new_weight)
            end 

            product_treatment_phase.lot_id = lot_previous.id
            
            if classification[:phase_id] == 1 
                Quantity.create(cost: (cost_kilo * product_treatment_phase.weight), weight: product_treatment_phase.weight, weight_initial: classification[:weight], product_id: product_treatment_phase.product_id, lot_id: lot_previous.id)     
            else
                Quantity.create(cost: (cost_kilo * product_treatment_phase.weight), weight: 0, weight_initial: classification[:weight], product_id: product_treatment_phase.product_id, lot_id: lot_previous.id)         
            end 

            ProductTreatmentPhase.transaction do 

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
                            if classification[:phase_id] == 1
                                Quantity.create(cost: (cost_kilo * classification[:weight]), weight: classification[:weight], weight_initial: classification[:weight], product_id: classification[:product_id], lot_id: lot_previous_classification.id)     
                            else
                                Quantity.create(cost: (cost_kilo * classification[:weight]), weight: 0, weight_initial: classification[:weight], product_id: classification[:product_id], lot_id: lot_previous_classification.id)            
                            end
                        end
                        render json: product_treatment_phase , each_serializer: ProductTreatmentPhaseClassificationSerializer 
                    end #--->>> closed unless
                else
                    render json: { message: "No se guardo la fase", errors: product_treatment_phase.errors }
                end  
            end # --->>> closed transaction 
        else
            render json: { message: "El peso de lo productos a clasificar es mayor al del inventario"}      
        end    
    end #--- >>> Closed method



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
        :product_id,
        :product_treatment_phase_id,
        product_treatments_attributes: [ :cost, :weight, :waste, :treatment_id, :treatment_new_name ]
      )
    end

     def classification_product_treatment_phase_params
     {   
       weight: params[:weight],
       cost: params[:cost],
       cost_treatments: params[:cost_treatments],
       name_treatments: params[:name_treatments],
       phase_id: params[:phase_id],
       product_id: params[:product_id],
       product_treatment_phase_id: params[:product_treatment_phase_id],
       classification: params[:classification]
       #classification: params[ classification[ weight: params[:weight], phase_id: params[:phase_id], product_id: params[:product_id] ] ]
    }
    end
end
