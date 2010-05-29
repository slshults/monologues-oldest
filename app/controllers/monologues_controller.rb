require 'vendor/plugins/active_record_extensions'
class MonologuesController < ApplicationController
  def index
    @monologues = Monologue.find(:all, :limit => 20)
  end
  
  def show
    @monologue = Monologue.find(params[:id])
  end

  def preview
    @monologue = Monologue.find(params[:id]) if params[:id]
    render :partial => 'preview', :layout => false
  end
  
  def new
    unless logged_in?
      redirect_to new_login_url
      return
    end
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
    unless logged_in?
      redirect_to new_login_url
      return
    end
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
    unless logged_in?
      redirect_to new_login_url
      return
    end
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

        case ActiveRecord::Base.connection.adapter_name
        when 'PostgreSQL'
             term_like_sql = '(plays.title ilike ? or character ilike ? or body ilike ?)'
        else
             term_like_sql = '(plays.title like ? or character like ? or body like ?)'
        end

        if params[:g]
          results = Monologue.find(
            :all,
            :conditions =>
              ['gender_id = ? and ' + term_like_sql,
                params[:g], "%#{term}%", "%#{term}%", "%#{term}%"],
            :joins => :play
          )
        else
          results = Monologue.find(
            :all,
            :conditions =>
              [term_like_sql,
              "%#{term}%", "%#{term}%", "%#{term}%"],
            :joins => :play
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
      @monologues = Monologue.find(:all, :limit => 20)
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
