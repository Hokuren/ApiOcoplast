require 'test_helper'

class ProductTreatmentPhasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_treatment_phase = product_treatment_phases(:one)
  end

  test "should get index" do
    get product_treatment_phases_url, as: :json
    assert_response :success
  end

  test "should create product_treatment_phase" do
    assert_difference('ProductTreatmentPhase.count') do
      post product_treatment_phases_url, params: { product_treatment_phase: { ProductTreatmentPhase_id: @product_treatment_phase.ProductTreatmentPhase_id, cost: @product_treatment_phase.cost, phase_id: @product_treatment_phase.phase_id, weight: @product_treatment_phase.weight } }, as: :json
    end

    assert_response 201
  end

  test "should show product_treatment_phase" do
    get product_treatment_phase_url(@product_treatment_phase), as: :json
    assert_response :success
  end

  test "should update product_treatment_phase" do
    patch product_treatment_phase_url(@product_treatment_phase), params: { product_treatment_phase: { ProductTreatmentPhase_id: @product_treatment_phase.ProductTreatmentPhase_id, cost: @product_treatment_phase.cost, phase_id: @product_treatment_phase.phase_id, weight: @product_treatment_phase.weight } }, as: :json
    assert_response 200
  end

  test "should destroy product_treatment_phase" do
    assert_difference('ProductTreatmentPhase.count', -1) do
      delete product_treatment_phase_url(@product_treatment_phase), as: :json
    end

    assert_response 204
  end
end
