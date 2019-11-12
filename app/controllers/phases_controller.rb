class PhasesController < ApplicationController
  before_action :set_phase, only: [:show, :update, :destroy]

  # GET /phases
  def index
    @phases = Phase.all

    render json: @phases
  end

  # GET /phases/1
  def show
    render json: @phase
  end

  # POST /phases
  def create
    @phase = Phase.new(phase_params)

    if @phase.save
      render json: @phase, status: :created, location: @phase
    else
      render json: @phase.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /phases/1
  def update
    if @phase.update(phase_params)
      render json: @phase
    else
      render json: @phase.errors, status: :unprocessable_entity
    end
  end

  # DELETE /phases/1
  def destroy
    @phase.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_phase
      @phase = Phase.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def phase_params
      params.require(:phase).permit(:name)
    end
end
