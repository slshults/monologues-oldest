require 'vendor/plugins/active_record_extensions'
class MonologuesController < ApplicationController
  def index
    @monologues = Monologue.paginate :page => params[:page], :per_page => 20
  end
  
  def show
    @monologue = Monologue.find(params[:id])
  end

  def preview
    @monologue = Monologue.find(params[:id]) if params[:id]
    render :partial => 'preview', :layout => false
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
      @plays = Play.all
      @genders = Gender.all
      render :action => 'new'
    end
  end
  
  def edit
    @monologue = Monologue.find(params[:id])
    @plays = Play.all
  end
  
  def update
    @monologue = Monologue.find(params[:id])
    if @monologue.update_attributes(params[:monologue])
      flash[:notice] = "Successfully updated monologue."
      redirect_to @monologue
    else
      @plays = Play.all
      @genders = Gender.all
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
    @ajax_search = params[:search]
    unless @ajax_search.blank?
      @terms = @ajax_search.split(" ")
      @monologues = []
      @terms.each do |term|
        
        if params[:g]
          results = Monologue.find(
            :all,
            :conditions =>
              ['gender_id = ? and (plays.title like ? or character like ? or body like ?)',
                params[:g], "%#{term}%", "%#{term}%", "%#{term}%"],
            :joins => 'LEFT JOIN plays ON plays.id = monologues.play_id'
          )
        else
          results = Monologue.find(
            :all,
            :conditions =>
              ['plays.title like ? or character like ? or body like ?',
              "%#{term}%", "%#{term}%", "%#{term}%"],
            :joins => 'LEFT JOIN plays ON plays.id = monologues.play_id'
          )
        end
        if results
          if @monologues.empty?
            @monologues = results
          else
            # append results for each seach term
            @monologues &= results
          end
        end

      end

      @monologues.compact!
      @monologues.uniq!

    else
      @monologues = Monologue.paginate :page => params[:page], :per_page => 20
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
