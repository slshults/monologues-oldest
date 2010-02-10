require 'test_helper'

class GendersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:genders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gender" do
    assert_difference('Gender.count') do
      post :create, :gender => {:name => 'Neutral' }
    end

    assert_redirected_to gender_path(assigns(:gender))
  end

#  test "should show gender" do
#    get :show, :id => genders(:men).to_param
#    assert_response :success
#  end

  test "should get edit" do
    get :edit, :id => genders(:men).to_param
    assert_response :success
  end

  test "should update gender" do
    put :update, :id => genders(:men).to_param, :gender => { }
    assert_redirected_to gender_path(assigns(:gender))
  end

  test "should destroy gender" do
    assert_difference('Gender.count', -1) do
      delete :destroy, :id => genders(:women).to_param
    end

    assert_redirected_to genders_path
  end
end
