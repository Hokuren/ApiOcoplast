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

    #begin 

      @quantity = Quantity.new(quantity_params)
      
      @producttreatmentphase = ProductTreatmentPhase.new(cost: 0, weight: 0)
      
      @producttreatmentphase.phase_id = 1

      @lot = Lot.new(cost: 0, weight: 0, waste: 0, available: 0, product_treatment_phase_id: @producttreatmentphase.id)
      
      puts 'que viene el json producttreatmentphase'
      puts @producttreatmentphase.inspect
      puts 'que viene el json quantity'
      puts @quantity.inspect
      puts 'que viene el json lot'
      puts @lot.inspect

      @producttreatmentphase.save! 
      @lot.product_treatment_phase_id = @producttreatmentphase.id
      
      if  @lot.save ### 2
        #render json: @lot, status: :created, location: @lot
      else
        #render json: @lot.errors, status: :unprocessable_entity
      end

      @quantity.lot_id = @lot.id

      puts 'quantity created'
      puts @quantity
      if @quantity.save ### 3
        render json: @quantity, status: :created, location: @quantity
      else
        render json: @quantity.errors, status: :unprocessable_entity
      end

    puts 'Is created'
   # rescue  

   #   puts 'Is not created'  
   # end  

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
