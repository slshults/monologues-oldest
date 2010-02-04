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
    unless params[:search].blank?
      @terms = params[:search].split(" ")
      @monologues = []
      @terms.each do |term|
        results = Monologue.find(:all, :conditions => "character like '%#{term}%' or body like '%#{term}%' or name like '%#{term}%'")
        @monologues = results if results and @monologues.empty?
        @monologues &= results if results
      end
      @monologues.compact!
      @monologues.uniq!
    else
      @monologues = Monologue.all
    end
    render :partial => 'search', :layout => false
  end

  def men
    @monologues = Monologue.find_all_by_gender_id(3)
    render :index
  end

  def women
    @monologues = Monologue.find_all_by_gender_id(2)
    render :index
  end

end
