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
    
        quantity = Quantity.new(quantity_params)
        quantity.weight_initial = quantity.weight

		return render json: { message: "El producto seleccionado no existe" } if Product.find_by(id: quantity.product_id).nil? 
            
        producttreatmentphase = ProductTreatmentPhase.new(cost: 0, weight: 0, lot_id: nil)
        producttreatmentphase.phase_id = 1
        producttreatmentphase.product_id = quantity.product_id
        lot = Lot.joins(:product_treatment_phases).where(product_treatment_phases: { phase_id: producttreatmentphase.phase_id  , product_id: quantity.product_id } ).first
        if lot.nil?
            lot = Lot.new(cost: 0, weight: 0, waste: 0, available: 0)
            lot.cost = ( quantity.cost / quantity.weight )
            lot.weight = quantity.weight
            if lot.save
                producttreatmentphase.lot_id = lot.id
                producttreatmentphase.cost = ( quantity.cost / quantity.weight )
                producttreatmentphase.weight = quantity.weight
                quantity.lot_id = lot.id
                producttreatmentphase.save
            end 
        else 
            lot_new_cost = (  ( (lot.cost * lot.weight) + (quantity.cost)  )/ ( lot.weight + quantity.weight )  )          
            lot_new_weight = ( lot.weight + quantity.weight )
            lot.update( cost: lot_new_cost, weight: lot_new_weight )
            lot.product_treatment_phases.where("product_treatment_phase_id is null or phase_id = 1" ).last.update( cost: lot_new_cost, weight: lot_new_weight )	
            quantity.lot_id = lot.id
        end 
        
        if quantity.save!
            render json: quantity, status: :created, location: quantity
        else
            render json: quantity.errors, status: :unprocessable_entity
        end  
    end # --->>> Colsed Transaction    
  end #--->>> Closed Method

  # PATCH/PUT /quantities/1
  def update
    binding.pry
    last_cost = @quantity.cost
    binding.pry
    last_weight =  @quantity.weight
    binding.pry
    cost_kilo = ( last_cost / last_weight )
    binding.pry

    binding.pry
    lot = Lot.find_by(id: @quantity.lot_id)
    binding.pry
    cost_lot_total = (lot.weight * lot.cost)
    binding.pry
    cost_lot_total = (cost_lot_total - last_cost)
    binding.pry 
    lot.weight = ( lot.weight - last_weight )
    binding.pry
    cost_kilo_lot = ( cost_lot_total / lot.weight )
    binding.pry
    lot.cost = cost_kilo_lot 
    binding.pry

    old_cost_lot = ( lot.weight * lot.cost )
    

    if @quantity.update(quantity_params)
      binding.pry
      render json: @quantity
      binding.pry
    else
      binding.pry
      render json: @quantity.errors, status: :unprocessable_entity
      binding.pry
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
      params.require(:quantity).permit(:cost, :weight, :date, :product_id, :lot_id)
    end

end
