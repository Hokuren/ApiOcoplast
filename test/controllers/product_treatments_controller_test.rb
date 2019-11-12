require 'test_helper'

class ProductTreatmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_treatment = product_treatments(:one)
  end

  test "should get index" do
    get product_treatments_url, as: :json
    assert_response :success
  end

  test "should create product_treatment" do
    assert_difference('ProductTreatment.count') do
      post product_treatments_url, params: { product_treatment: { ProductTreatmentPhase_id: @product_treatment.ProductTreatmentPhase_id, ProductTreatment_id: @product_treatment.ProductTreatment_id, Treatment_id: @product_treatment.Treatment_id, cost: @product_treatment.cost, waste: @product_treatment.waste, weight: @product_treatment.weight } }, as: :json
    end

    assert_response 201
  end

  test "should show product_treatment" do
    get product_treatment_url(@product_treatment), as: :json
    assert_response :success
  end

  test "should update product_treatment" do
    patch product_treatment_url(@product_treatment), params: { product_treatment: { ProductTreatmentPhase_id: @product_treatment.ProductTreatmentPhase_id, ProductTreatment_id: @product_treatment.ProductTreatment_id, Treatment_id: @product_treatment.Treatment_id, cost: @product_treatment.cost, waste: @product_treatment.waste, weight: @product_treatment.weight } }, as: :json
    assert_response 200
  end

  test "should destroy product_treatment" do
    assert_difference('ProductTreatment.count', -1) do
      delete product_treatment_url(@product_treatment), as: :json
    end

    assert_response 204
  end
end
