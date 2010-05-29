# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :logged_in?

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  private
  # force user to login if they are not already
  def authorize!
    unless logged_in?
      redirect_to new_login_url
      return
    end
  end

  # true if user is already logged in
  def logged_in?
    if session[:user_id] && User.find(:first, :conditions => ["id = ?", session[:user_id]])
      @current_user = User.find( session[:user_id] )
    else
      @current_user = nil
#      redirect_to new_login_url
    end
  end

end