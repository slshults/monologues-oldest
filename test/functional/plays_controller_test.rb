require 'test_helper'
require 'spec/matchers'

class PlaysControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plays)
  end

  test "should get new when logged in" do
    PlaysController.any_instance.stubs(:logged_in?).returns(true)
    get :new
    assert_response :success
  end

  test "should not get new unless logged in" do
    # not logged in
    get :new
    assert_response :redirect
  end

  test "should create play" do
    assert_difference('Play.count') do
      post :create, :play => {:title => 'One night in Burbank', :author_id => 1, :classification => 'Comedy' }
    end
    assert_redirected_to play_path(assigns(:play))
  end

  test "should show play" do
    get :show, :id => plays(:hamlet).to_param
    assert_response :success
  end

  test "should get edit when logged in" do
    PlaysController.any_instance.stubs(:logged_in?).returns(true)
    get :edit, :id => plays(:hamlet).to_param
    assert_response :success
  end

  test "should not get edit unless logged in" do
    # not logged in
    get :edit, :id => plays(:hamlet).to_param
    assert_response :redirect
  end

  test "should update play" do
    put :update, :id => plays(:hamlet).to_param, :play => { }
    assert_redirected_to play_path(assigns(:play))
  end

  test "should destroy play" do
    PlaysController.any_instance.stubs(:logged_in?).returns(true)
    assert_difference('Play.count', -1) do
      delete :destroy, :id => plays(:hamlet).to_param
    end

    assert_redirected_to plays_path
  end
end
