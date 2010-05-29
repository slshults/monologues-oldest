require 'test_helper'

class AuthorsControllerTest < ActionController::TestCase
  test "should get index when logged in" do
    AuthorsController.any_instance.stubs(:logged_in?).returns(true)
    get :index
    assert_response :success
    assert_not_nil assigns(:authors)
  end

  test "should get new when logged in" do
    AuthorsController.any_instance.stubs(:logged_in?).returns(true)
    get :new
    assert_response :success
  end

  test "should create author when logged in" do
    AuthorsController.any_instance.stubs(:logged_in?).returns(true)
    assert_difference('Author.count') do
      post :create, :author => {:name => 'Gates' }
    end

    assert_redirected_to author_path(assigns(:author))
  end

  test "should show author when logged in" do
    AuthorsController.any_instance.stubs(:logged_in?).returns(true)
    get :show, :id => authors(:shakespeare).to_param
    assert_response :success
  end

  test "should get edit when logged in" do
    AuthorsController.any_instance.stubs(:logged_in?).returns(true)
    get :edit, :id => authors(:shakespeare).to_param
    assert_response :success
  end

#  test "should update author" do
#    put :update, :id => authors(:shakespeare).to_param, :author => {:name => 'shakes'}
#    assert_redirected_to author_url(assigns(:author))
#  end
#
  test "should destroy author when logged in" do
    AuthorsController.any_instance.stubs(:logged_in?).returns(true)
    assert_difference('Author.count', -1) do
      delete :destroy, :id => authors(:shakespeare).to_param
    end

    assert_redirected_to authors_path
  end
end
