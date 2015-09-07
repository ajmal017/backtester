require 'test_helper'

class HoldingsControllerTest < ActionController::TestCase
  setup do
    @holding = holdings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:holdings)
  end

  test "should create holding" do
    assert_difference('Holding.count') do
      post :create, holding: { portfolio_id: @holding.portfolio_id, security_id: @holding.security_id, weight: @holding.weight }
    end

    assert_response 201
  end

  test "should show holding" do
    get :show, id: @holding
    assert_response :success
  end

  test "should update holding" do
    put :update, id: @holding, holding: { portfolio_id: @holding.portfolio_id, security_id: @holding.security_id, weight: @holding.weight }
    assert_response 204
  end

  test "should destroy holding" do
    assert_difference('Holding.count', -1) do
      delete :destroy, id: @holding
    end

    assert_response 204
  end
end
