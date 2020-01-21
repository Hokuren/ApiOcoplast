class ProductTreatmentsController < ApplicationController
  before_action :set_product_treatment, only: [:show, :update, :destroy]

  # GET /product_treatments
  def index
    @product_treatments = ProductTreatment.all

    render json: @product_treatments
  end

  # GET /product_treatments/1
  def show
    render json: @product_treatment
  end

  # POST /product_treatments
  def create
    @product_treatment = ProductTreatment.new(product_treatment_params)

    # Si la cantidad de la face es mayor o igual al los tratamientos 
    lot_phase = ProductTreatmentPhase.find(@product_treatment.product_treatment_phase_id).lots.last
    
    if lot_phase.weight >= @product_treatment.weight

      if @product_treatment.save
        render json: @product_treatment, status: :created, location: @product_treatment
      else
        render json: @product_treatment.errors, status: :unprocessable_entity
      end

    else 
        render json: { message: "la cantidad de tratamiento no puede ser mayor al lote de las face"}
        puts "la cantidad de tratamiento no puede ser mayor al lote de las face ( lote : #{ lot_phase.weight }  <->  Phase : #{ @product_treatment.weight } ) "
    end  

  end

  # PATCH/PUT /product_treatments/1
  def update
    if @product_treatment.update(product_treatment_params)
      render json: @product_treatment
    else
      render json: @product_treatment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /product_treatments/1
  def destroy
    @product_treatment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_treatment
      @product_treatment = ProductTreatment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_treatment_params
      params.require(:product_treatment).permit(:cost, :weight, :waste, :treatment_id, :product_treatment_phase_id, :product_treatment_id)
    end
end
