class AdminController < ApplicationController

  def index
    unless logged_in?
      redirect_to new_login_url
      return
    end

  end

end