require 'test_helper'

class UserRestaurantConfigsControllerTest < ActionController::TestCase
  setup do
    @user_restaurant_config = user_restaurant_configs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_restaurant_configs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_restaurant_config" do
    assert_difference('UserRestaurantConfig.count') do
      post :create, user_restaurant_config: @user_restaurant_config.attributes
    end

    assert_redirected_to user_restaurant_config_path(assigns(:user_restaurant_config))
  end

  test "should show user_restaurant_config" do
    get :show, id: @user_restaurant_config.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_restaurant_config.to_param
    assert_response :success
  end

  test "should update user_restaurant_config" do
    put :update, id: @user_restaurant_config.to_param, user_restaurant_config: @user_restaurant_config.attributes
    assert_redirected_to user_restaurant_config_path(assigns(:user_restaurant_config))
  end

  test "should destroy user_restaurant_config" do
    assert_difference('UserRestaurantConfig.count', -1) do
      delete :destroy, id: @user_restaurant_config.to_param
    end

    assert_redirected_to user_restaurant_configs_path
  end
end
