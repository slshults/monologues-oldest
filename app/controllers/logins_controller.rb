class LoginsController < ApplicationController
  
  def new
    session[:user_id] = nil
    render :new
  end
  
  def create
    u = User.authenticate(params[:user][:email], params[:user][:password])
    if u
      session[:user_id] = u.id
      flash[:notice] = nil
      redirect_to '/admin'
    else
      session[:user_id] = nil
      flash[:notice] = "incorrect email and/or password"
      APPLOG.warn "Failed login from #{request.env['REMOTE_ADDR']}"
      render :new
    end
  end
    
  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been logged out"
    redirect_to monologues_path
  end
end
