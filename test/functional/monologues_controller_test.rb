require 'test_helper'

class MonologuesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:monologues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create monologue" do
    assert_difference('Monologue.count') do
      post :create, :monologue => { }
    end

    assert_redirected_to monologue_path(assigns(:monologue))
  end

  test "should show monologue" do
    get :show, :id => monologues(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => monologues(:one).to_param
    assert_response :success
  end

  test "should update monologue" do
    put :update, :id => monologues(:one).to_param, :monologue => { }
    assert_redirected_to monologue_path(assigns(:monologue))
  end

  test "should destroy monologue" do
    assert_difference('Monologue.count', -1) do
      delete :destroy, :id => monologues(:one).to_param
    end

    assert_redirected_to monologues_path
  end
end
