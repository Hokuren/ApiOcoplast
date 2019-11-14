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

    begin 
      puts "--->>>inicio try<<<---"      
      @quantity = Quantity.new(quantity_params)
      
      @producttreatmentphase = ProductTreatmentPhase.new(cost: 0, weight: 0)
      
      @producttreatmentphase.phase_id = 1
     
      @lot = Lot.new(cost: 0, weight: 0, waste: 0, available: 0, product_treatment_phase_id: @producttreatmentphase.id)
        
      if Lot.where(cost: 0).joins(:quantities).where(quantities: { product_id: @quantity.product_id }).size  == 0

        puts "--->>> inicio if <<<---"
        #Lot.last.nil?
        ### 1
        @producttreatmentphase.save!  
        @lot.product_treatment_phase_id = @producttreatmentphase.id
        ### 2
        @lot.save 

        @quantity.lot_id = @lot.id
      else 
        puts "--->>> inicio else <<<---"
        @quantity.lot_id = Lot.last.id
      end 
       
      puts "--->>> inspeccionando la cantidad <<<---"
      puts @quantity.inspect 
      if @quantity.save 
        render json: @quantity, status: :created, location: @quantity
      else
        render json: @quantity.errors, status: :unprocessable_entity
      end

      puts 'Is created'
    rescue  
      puts 'Is not created'  
    end  

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
