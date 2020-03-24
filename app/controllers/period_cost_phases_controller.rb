class PeriodCostPhasesController < ApplicationController
  before_action :set_period_cost_phase, only: [:show, :update, :destroy]

  # GET /period_cost_phases
  # GET /period_cost_phases.json
  def index
    @period_cost_phases = PeriodCostPhase.all
    if @period_cost_phases.nil? 
      render json: @period_cost_phase.errors
    else
      render json: @period_cost_phases
    end
  end

  # GET /period_cost_phases/1
  # GET /period_cost_phases/1.json
  def show
    render  json: @period_cost_phase
  end

  # POST /period_cost_phases
  # POST /period_cost_phases.json
  def create
    @period_cost_phase = PeriodCostPhase.new(period_cost_phase_params)

    if @period_cost_phase.save
      render :show, status: :created, location: @period_cost_phase
    else
      render json: @period_cost_phase.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /period_cost_phases/1
  # PATCH/PUT /period_cost_phases/1.json
  def update
    if @period_cost_phase.update(period_cost_phase_params)
      render :show, status: :ok, location: @period_cost_phase
    else
      render json: @period_cost_phase.errors, status: :unprocessable_entity
    end
  end

  # DELETE /period_cost_phases/1
  # DELETE /period_cost_phases/1.json
  def destroy
    @period_cost_phase.destroy
  end

  def costs_phase

    period_cost_phase = PeriodCostPhase.where(period_id: params[:period_id], phase_id: params[:phase_id])

    if period_cost_phase.nil? || period_cost_phase.empty?
      render json: period_cost_phase
    else
      render json: period_cost_phase, each_serializer: CostsPhaseSerializer 
    end  

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_period_cost_phase
      @period_cost_phase = PeriodCostPhase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def period_cost_phase_params
      params.require(:period_cost_phase).permit(:type_cost, :cost, :cost_porcentage, :porcentage, :period_id, :cost_id, :phase_id)
    end
end
