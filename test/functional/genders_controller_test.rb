require 'test_helper'

class GendersControllerTest < ActionController::TestCase

  test "should not get index unless logged in" do
    get :index
    assert_redirected_to new_login_url
  end


  test "should not get new unless logged in" do
    get :new
    assert_redirected_to new_login_url
  end

#  test "should get index when logged in" do
#    get :index
#    assert_response :success
#    assert_not_nil assigns(:genders)
#  end


# can't run route tests because of dynamic code in routes.rb
# #  test "should get men" do
#    get :men
#    assert_response :success
#  end
#
#  test "should get women" do
#    get :women
#    assert_response :success
#  end

  
#  test "should get new when logged in" do
#    # stub the login
#    
#    get :new
#    assert_response :success
#  end

#  test "should create gender" do
#
#    assert_difference('Gender.count') do
#      post :create, :gender => {:name => 'Neutral' }
#    end
#
#    assert_redirected_to gender_path(assigns(:gender))
#  end

#  test "should show gender" do
#    get :show, :id => genders(:men).to_param
#    assert_response :success
#  end

  test "should not get edit unless logged in" do
    get :edit, :id => genders(:men).to_param
    assert_redirected_to new_login_url
  end

#  test "should update gender" do
#    GendersControlleer.any_instance.stubs(:logged_in?).returns(true)
#    # => NameError: uninitialized constant GendersControllerTest::GendersControlleer
#
#    put :update, :id => genders(:men).to_param, :gender => {:name => 'boy' }
#    assert_redirected_to :controller => 'gender', :action => 'men'
#    assert Gender.find(:conditions => 'name = "men"')
#  end

#  test "should destroy gender" do
#    assert_difference('Gender.count', -1) do
#      delete :destroy, :id => genders(:women).to_param
#    end
#
#    assert_redirected_to genders_path
#  end

end
