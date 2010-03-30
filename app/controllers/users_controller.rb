class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
  
  def index
    @users = User.paginate :page => params[:page], :per_page => 2
  end

  def edit
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = "Welcome #{@user.email}, your account has been created."
        session[:user_id] = @user.id
        format.html { redirect_to( root_path ) }
      else
        format.html { render :controller => "sessions", :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes params[:user]
    redirect_to @user
  end
end