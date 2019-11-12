require 'test_helper'

class PhasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @phase = phases(:one)
  end

  test "should get index" do
    get phases_url, as: :json
    assert_response :success
  end

  test "should create phase" do
    assert_difference('Phase.count') do
      post phases_url, params: { phase: { name: @phase.name } }, as: :json
    end

    assert_response 201
  end

  test "should show phase" do
    get phase_url(@phase), as: :json
    assert_response :success
  end

  test "should update phase" do
    patch phase_url(@phase), params: { phase: { name: @phase.name } }, as: :json
    assert_response 200
  end

  test "should destroy phase" do
    assert_difference('Phase.count', -1) do
      delete phase_url(@phase), as: :json
    end

    assert_response 204
  end
end
