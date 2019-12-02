  class QuantitiesController < ApplicationController
    before_action :set_quantity, only: [:show, :update, :destroy]

  # GET /quantities
  def index
    @quantities = Quantity.all

    render json: @quantities
  end

  # GET /quantities/1
  def show
    render json: @quantity
  end


  # POST /quantities
  def create 
    Quantity.transaction do
        @quantity = Quantity.new(quantity_params)
        @quantity.weight_initial = @quantity.weight
        if Product.find_by(id: @quantity.product_id).nil?
            render json: { message: "El producto seleccionado no existe" }    
        else    
            puts "El producto que enviaste si existe"
            @lot = Lot.new(cost: 0, weight: 0, waste: 0, available: 0)
            @producttreatmentphase = ProductTreatmentPhase.new(cost: 0, weight: 0, lot_id: @lot.id)
            @producttreatmentphase.phase_id = 1
            @producttreatmentphase.product_id = @quantity.product_id
            ##si hay un lote  del producto
            ##lot = Lot.where(cost: 0).joins(:quantities).where(quantities: { product_id: @quantity.product_id }).size 
			lot = Lot.joins(:quantities , :product_treatment_phases).where(quantities: { product_id: @quantity.product_id } , product_treatment_phases: { product_treatment_phase_id: nil } ).last
            ##if lot == 0
			if lot.nil?
				puts "--->>> inicio if <<<---"
				@lot.cost = ( @quantity.cost / @quantity.weight )
				@lot.weight = @quantity.weight
				if @lot.save
                    @producttreatmentphase.lot_id = @lot.id
                    @producttreatmentphase.cost = ( @quantity.cost / @quantity.weight )
                    @producttreatmentphase.weight = @quantity.weight
                    @quantity.lot_id = @lot.id
					@producttreatmentphase.save
                end 
            else 
                puts "--->>> inicio else <<<---"
                #lot_new_cost = (  ( (lot.cost * lot.weight) + (@quantity.cost)  )/ ( lot.weight + @quantity.weight )  )              
				#lot_new_weight = lot.weight + @quantity.weight
				binding.pry
				quantities = Quantity.joins(:lot).where(lot_id: lot.id)
				lot_new_cost = 0
				lot_new_weight = 0
				cost_quantities = 0
				weight_quantities = 0
				binding.pry
				quantities.each do |quantity|
					binding.pry
					cost_quantities = cost_quantities + ( ( quantity.cost / quantity.weight_initial ) *  quantity.weight)
					weight_quantities = weight_quantities + quantity.weight
					binding.pry
				end
				binding.pry
				lot_new_cost = (  (cost_quantities + @quantity.cost) / ( weight_quantities + @quantity.weight )  )              
				lot_new_weight = weight_quantities + @quantity.weight
				binding.pry
                lot.update( cost: lot_new_cost, weight: lot_new_weight )
                lot.product_treatment_phases.where(product_treatment_phase_id: nil).last.update( cost: lot_new_cost, weight: lot_new_weight )		
                @quantity.lot_id = lot.id
            end 
          
            if @quantity.save!
                render json: @quantity, status: :created, location: @quantity
            else
                render json: @quantity.errors, status: :unprocessable_entity
            end
        end
    end # --->>> Colsed Transaction    
  end #--->>> Closed Method

  # PATCH/PUT /quantities/1
  def update
    if @quantity.update(quantity_params)
      render json: @quantity
    else
      render json: @quantity.errors, status: :unprocessable_entity
    end
  end

  # DELETE /quantities/1
  def destroy
    @quantity.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quantity
      @quantity = Quantity.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def quantity_params
      params.require(:quantity).permit(:cost, :weight, :product_id, :lot_id)
    end
end
