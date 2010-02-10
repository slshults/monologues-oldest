require 'test_helper'

class PlaysControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plays)
  end

  test "should get new" do
    get :new
    assert_response :success
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

  test "should get edit" do
    get :edit, :id => plays(:hamlet).to_param
    assert_response :success
  end

  test "should update play" do
    put :update, :id => plays(:hamlet).to_param, :play => { }
    assert_redirected_to play_path(assigns(:play))
  end

  test "should destroy play" do
    assert_difference('Play.count', -1) do
      delete :destroy, :id => plays(:hamlet).to_param
    end

    assert_redirected_to plays_path
  end
end
