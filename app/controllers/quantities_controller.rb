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
        if Product.find_by(id: @quantity.product_id).nil?
            render json: "El producto seleccionado no existe"    
        else
            puts "El producto que enviaste si existe"
            binding.pry
            @lot = Lot.new(cost: 0, weight: 0, waste: 0, available: 0)
            binding.pry
            @producttreatmentphase = ProductTreatmentPhase.new(cost: 0, weight: 0, lot_id: @lot.id)
            binding.pry
            @producttreatmentphase.phase_id = 1
            binding.pry
            #si hay un lote con costo 0 del producto 
            lot = Lot.where(cost: 0).joins(:quantities).where(quantities: { product_id: @quantity.product_id }).size 
            binding.pry
            if lot == 0
                puts "--->>> inicio if <<<---"
                binding.pry
                @lot.save 
                @producttreatmentphase.lot_id = @lot.id 
                @producttreatmentphase.save! 
                @quantity.lot_id = @lot.id
                binding.pry
            else 
                puts "--->>> inicio else <<<---"
                binding.pry
                @quantity.lot_id = Lot.last.id
                binding.pry
            end 
        end
        
        if @quantity.save!
            render json: @quantity, status: :created, location: @quantity
        else
            render json: @quantity.errors, status: :unprocessable_entity
        end
    end # --->>> Colsed Transaction    
    # termina oscar
  end

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
