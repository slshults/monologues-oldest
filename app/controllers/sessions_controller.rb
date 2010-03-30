class SessionsController < ApplicationController

  def new
    # @user = User.new
  end

  def destroy
    self.current_user = nil
    redirect_to root_path
  end

  def create
    if user = User.authenticate(params[:email], params[:password])
      self.current_user = user
      flash[:notice] = 'Welcome ' + params[:email] + '!'
      redirect_to root_path
    else
      flash.now[:error] =  "Couldn't locate a user with those credentials"
      render :action => :new
    end
  end
end