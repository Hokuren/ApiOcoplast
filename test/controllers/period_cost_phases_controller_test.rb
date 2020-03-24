require 'test_helper'

class PeriodCostPhasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @period_cost_phase = period_cost_phases(:one)
  end

  test "should get index" do
    get period_cost_phases_url, as: :json
    assert_response :success
  end

  test "should create period_cost_phase" do
    assert_difference('PeriodCostPhase.count') do
      post period_cost_phases_url, params: { period_cost_phase: { cost: @period_cost_phase.cost, cost_id: @period_cost_phase.cost_id, cost_porcentage: @period_cost_phase.cost_porcentage, period_id: @period_cost_phase.period_id, phase_id: @period_cost_phase.phase_id, porcentage: @period_cost_phase.porcentage, type: @period_cost_phase.type } }, as: :json
    end

    assert_response 201
  end

  test "should show period_cost_phase" do
    get period_cost_phase_url(@period_cost_phase), as: :json
    assert_response :success
  end

  test "should update period_cost_phase" do
    patch period_cost_phase_url(@period_cost_phase), params: { period_cost_phase: { cost: @period_cost_phase.cost, cost_id: @period_cost_phase.cost_id, cost_porcentage: @period_cost_phase.cost_porcentage, period_id: @period_cost_phase.period_id, phase_id: @period_cost_phase.phase_id, porcentage: @period_cost_phase.porcentage, type: @period_cost_phase.type } }, as: :json
    assert_response 200
  end

  test "should destroy period_cost_phase" do
    assert_difference('PeriodCostPhase.count', -1) do
      delete period_cost_phase_url(@period_cost_phase), as: :json
    end

    assert_response 204
  end
end
