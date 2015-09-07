require 'test_helper'

class SecuritiesControllerTest < ActionController::TestCase
  setup do
    @security = securities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:securities)
  end

  test "should create security" do
    assert_difference('Security.count') do
      post :create, security: { identifier: @security.identifier, name: @security.name, ticker: @security.ticker }
    end

    assert_response 201
  end

  test "should show security" do
    get :show, id: @security
    assert_response :success
  end

  test "should update security" do
    put :update, id: @security, security: { identifier: @security.identifier, name: @security.name, ticker: @security.ticker }
    assert_response 204
  end

  test "should destroy security" do
    assert_difference('Security.count', -1) do
      delete :destroy, id: @security
    end

    assert_response 204
  end
end
