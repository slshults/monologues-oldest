# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  before_filter :logged_in?

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  private
  def logged_in?
    if session[:user_id] && User.find(:first, :conditions => ["id = ?", session[:user_id]])
      @current_user = User.find( session[:user_id] )
    else
      @current_user = nil
#      redirect_to new_login_url
    end
  end

####
# Authlogic
#
#
#   before_filter :require_user
#
#  # Scrub sensitive parameters from your log
#  # filter_parameter_logging :password
#
#  private
#
#  def current_user_session
#    return @current_user_session if defined?(@current_user_session)
#    @current_user_session = UserSession.find
#  end
#
#  def current_user
#    return @current_user if defined?(@current_user)
#    @current_user = current_user_session && current_user_session.record
#  end
#
#  def require_user
#    unless current_user
#      store_location
#      flash[:notice] = "You must be logged in to access this page"
#      redirect_to new_user_session_url
#      return false
#    end
#  end
#
#  def require_no_user
#    if current_user
#      store_location
#      flash[:notice] = "You must be logged out to access this page"
#      redirect_to account_url
#      return false
#    end
#  end
#
#  def store_location
#    session[:return_to] = request.request_uri
#  end
#
#  def redirect_back_or_default(default)
#    redirect_to(session[:return_to] || default)
#    session[:return_to] = nil
#  end
#
#  helper_method :current_project
#  def current_project
#    project = Project.find(session[:project_id]) rescue Project.last
#  end
#
#  def redirect_if_not_current_user(user_id)
#    if user_id && user_id != current_user.id
#      current_user_session.destroy
#      redirect_to new_user_session_path
#      return true
#    end
#    false
#  end
end
