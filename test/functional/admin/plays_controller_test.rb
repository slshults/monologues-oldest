require 'test_helper'
require 'spec/matchers'

class Admin::PlaysControllerTest < ActionController::TestCase
  test "should get index" do
    Admin::PlaysController.any_instance.stubs(:logged_in?).returns(true)
    get :index
    assert_response :success
    assert_not_nil assigns(:plays)
  end

  test "should show play" do
    Admin::PlaysController.any_instance.stubs(:logged_in?).returns(true)
    get :show, :id => plays(:hamlet).to_param
    assert_response :success
  end

  test "should show monologues by play" do
    Admin::PlaysController.any_instance.stubs(:logged_in?).returns(true)
    hamlet = Play.find_by_title('Hamlet')

    get :show, :id => hamlet.id
    assert @response.body.include? 'Hamlet'
    assert @response.body.include? 'To be, or not to be'
    assert @response.body.include? 'O what a noble mind'
  end

end
