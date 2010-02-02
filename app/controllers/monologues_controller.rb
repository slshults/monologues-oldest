require 'vendor/plugins/active_record_extensions'
class MonologuesController < ApplicationController
  def index
    @monologues = Monologue.all
  end
  
  def show
    @monologue = Monologue.find(params[:id])
  end
  
  def new
    @monologue = Monologue.new
    @plays = Play.all
    @genders = Gender.all
  end
  
  def create
    @monologue = Monologue.new(params[:monologue])
    if @monologue.save
      flash[:notice] = "Successfully created monologue."
      redirect_to @monologue
    else
      render :action => 'new'
    end
  end
  
  def edit
    @monologue = Monologue.find(params[:id])
  end
  
  def update
    @monologue = Monologue.find(params[:id])
    if @monologue.update_attributes(params[:monologue])
      flash[:notice] = "Successfully updated monologue."
      redirect_to @monologue
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @monologue = Monologue.find(params[:id])
    @monologue.destroy
    flash[:notice] = "Successfully destroyed monologue."
    redirect_to monologues_url
  end

  def search
    #require 'ruby-debug';debugger
    unless params[:search].blank?
      @monologues = Monologue.find(:all, :conditions => "name like '%#{params[:search]}%'")
    else
      @monologues = Monologue.all
    end
    render :partial => 'search', :layout => false
  end
end
=begin
paginate(:page => params[:page],
                            :per_page => 10,
                            :order => order_from_params,
                            :conditions => Monologues.conditions_by_like(params[:search]))
=end