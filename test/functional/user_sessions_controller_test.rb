#---
# Excerpted from "Rails Test Prescriptions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/nrtest for more book information.
#---
require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user session" do
    post :create, :user_session => { :login => "bjohnson", :password => "benrocks" }
    assert user_session = UserSession.find
    assert_equal users(:ben), user_session.user
    assert_redirected_to projects_path
  end

  test "should destroy user session" do
    delete :destroy
    assert_nil UserSession.find
    assert_redirected_to new_user_session_path
  end
end
