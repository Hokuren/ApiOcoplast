require 'test_helper'

class TreatmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @treatment = treatments(:one)
  end

  test "should get index" do
    get treatments_url, as: :json
    assert_response :success
  end

  test "should create treatment" do
    assert_difference('Treatment.count') do
      post treatments_url, params: { treatment: { name: @treatment.name } }, as: :json
    end

    assert_response 201
  end

  test "should show treatment" do
    get treatment_url(@treatment), as: :json
    assert_response :success
  end

  test "should update treatment" do
    patch treatment_url(@treatment), params: { treatment: { name: @treatment.name } }, as: :json
    assert_response 200
  end

  test "should destroy treatment" do
    assert_difference('Treatment.count', -1) do
      delete treatment_url(@treatment), as: :json
    end

    assert_response 204
  end
end
