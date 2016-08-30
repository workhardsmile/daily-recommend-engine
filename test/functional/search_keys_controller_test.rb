require 'test_helper'

class SearchKeysControllerTest < ActionController::TestCase
  setup do
    @search_key = search_keys(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:search_keys)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create search_key" do
    assert_difference('SearchKey.count') do
      post :create, search_key: @search_key.attributes
    end

    assert_redirected_to search_key_path(assigns(:search_key))
  end

  test "should show search_key" do
    get :show, id: @search_key.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @search_key.to_param
    assert_response :success
  end

  test "should update search_key" do
    put :update, id: @search_key.to_param, search_key: @search_key.attributes
    assert_redirected_to search_key_path(assigns(:search_key))
  end

  test "should destroy search_key" do
    assert_difference('SearchKey.count', -1) do
      delete :destroy, id: @search_key.to_param
    end

    assert_redirected_to search_keys_path
  end
end
