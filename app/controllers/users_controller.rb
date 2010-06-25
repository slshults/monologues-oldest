class UsersController < ApplicationController
  def index
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @users = User.all
    render :action => 'index', :layout => 'admin'
  end

  def new
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @user = User.new
    render :action => 'new', :layout => 'admin'
  end

  def create
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = "An account for #{@user.name} (#{@user.email}) has been created."
        APPLOG.info "User: #{@user.email} created by #{User.find_by_id(session[:user_id]).email} from #{request.env['REMOTE_ADDR']}"
        format.html { redirect_to( root_path ) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "Successfully destroyed user."
    redirect_to users_url
  end


end