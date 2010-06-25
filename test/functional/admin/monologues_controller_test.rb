  require 'test_helper'

class Admin::MonologuesControllerTest < ActionController::TestCase
  def test_index
    Admin::MonologuesController.any_instance.stubs(:logged_in?).returns(true)
    get :index
    assert_template 'index'
  end
  
  def test_show
    Admin::MonologuesController.any_instance.stubs(:logged_in?).returns(true)
    get :show, :id => Monologue.first
    assert_template 'show'
  end

  test "should view monologue" do
    Admin::MonologuesController.any_instance.stubs(:logged_in?).returns(true)
    get :show, :id => monologues(:is_this_a_dagger)
    assert_response :success
    assert_select "div"
  end

end
