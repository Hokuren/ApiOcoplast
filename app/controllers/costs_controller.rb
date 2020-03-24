class CostsController < ApplicationController
  before_action :set_cost, only: [:show, :update, :destroy]

  # GET /costs
  # GET /costs.json
  def index
    @costs = Cost.all
  end

  # GET /costs/1
  # GET /costs/1.json
  def show
    if @cost.nil? 
      render json: @cost.errors, status: :unprocessable_entity
    else
      render json: @cost
    end
  end

  # POST /costs
  # POST /costs.json
  def create
    @cost = Cost.new(cost_params)

    if @cost.save
      render :show, status: :created, location: @cost
    else
      render json: @cost.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /costs/1
  # PATCH/PUT /costs/1.json
  def update
    if @cost.update(cost_params)
      render :show, status: :ok, location: @cost
    else
      render json: @cost.errors, status: :unprocessable_entity
    end
  end

  # DELETE /costs/1
  # DELETE /costs/1.json
  def destroy
    @cost.destroy
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cost
      @cost = Cost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cost_params
      params.require(:cost).permit(:name, :cost)
    end
end
