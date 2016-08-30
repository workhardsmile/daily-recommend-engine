require 'test_helper'

class FrequentSetsControllerTest < ActionController::TestCase
  setup do
    @frequent_set = frequent_sets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:frequent_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create frequent_set" do
    assert_difference('FrequentSet.count') do
      post :create, frequent_set: @frequent_set.attributes
    end

    assert_redirected_to frequent_set_path(assigns(:frequent_set))
  end

  test "should show frequent_set" do
    get :show, id: @frequent_set.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @frequent_set.to_param
    assert_response :success
  end

  test "should update frequent_set" do
    put :update, id: @frequent_set.to_param, frequent_set: @frequent_set.attributes
    assert_redirected_to frequent_set_path(assigns(:frequent_set))
  end

  test "should destroy frequent_set" do
    assert_difference('FrequentSet.count', -1) do
      delete :destroy, id: @frequent_set.to_param
    end

    assert_redirected_to frequent_sets_path
  end
end
