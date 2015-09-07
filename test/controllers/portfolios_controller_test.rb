require 'test_helper'

class PortfoliosControllerTest < ActionController::TestCase
  setup do
    @portfolio = portfolios(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:portfolios)
  end

  test "should create portfolio" do
    assert_difference('Portfolio.count') do
      post :create, portfolio: { name: @portfolio.name }
    end

    assert_response 201
  end

  test "should show portfolio" do
    get :show, id: @portfolio
    assert_response :success
  end

  test "should update portfolio" do
    put :update, id: @portfolio, portfolio: { name: @portfolio.name }
    assert_response 204
  end

  test "should destroy portfolio" do
    assert_difference('Portfolio.count', -1) do
      delete :destroy, id: @portfolio
    end

    assert_response 204
  end
end
