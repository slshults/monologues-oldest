require 'vendor/plugins/active_record_extensions'
class MonologuesController < ApplicationController
  def index
#    @monologues = Monologue.find(:all, :limit => 20)
    @comedies = Play.find_all_by_classification('Comedy')
    @histories = Play.find_all_by_classification('History')
    @tragedies = Play.find_all_by_classification('Tragedy')
    render :index
  end
  
  def show
    @monologue = Monologue.find(params[:id])
    render :show
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
    @gender_id = params[:g]
    @play_id = params[:p]

    if @ajax_search.blank?

      # no search terms

      if @play_id and @gender_id
        @monologues = Monologue.find_all_by_gender_id_and_play_id(@gender_id, @play_id)

      elsif @play_id
        @monologues = Monologue.find_all_by_play_id(@play_id)
        
      elsif @gender_id
        @monologues = Monologue.find_all_by_gender_id(@gender_id, :limit => 20)
      else
        @monologues = Monologue.all(:limit => 20)
      end

    else
      @terms = @ajax_search.split(" ")
      @monologues = []
      @terms.each do |term|
        
        # set the default value for term_like_sql
        case ActiveRecord::Base.connection.adapter_name
        when 'PostgreSQL'
          term_like_sql = '(plays.title ilike ? or character ilike ? or body ilike ?)'
          term_like_sql_no_play = '(character ilike ? or body ilike ?)'
        else
          term_like_sql = '(plays.title like ? or character like ? or body like ?)'
          term_like_sql_no_play = '(character like ? or body like ?)'
        end


        if @gender_id and @play_id

          # gender and play specified
          results = Monologue.find(
            :all,
            :conditions =>
              ['gender_id = ? and play_id = ? and ' + term_like_sql_no_play,
                @gender_id, @play_id, "%#{term}%", "%#{term}%"],
            :joins => :play
          )
        elsif @play_id

          # play specified
          results = Monologue.find(
            :all,
            :conditions =>
              ['play_id = ? and ' + term_like_sql_no_play,
                @play_id, "%#{term}%", "%#{term}%"],
            :joins => :play
          )
        elsif params[:g]

          # gender specified
          results = Monologue.find(
            :all,
            :conditions =>
              ['gender_id = ? and ' + term_like_sql,
                @gender_id, "%#{term}%", "%#{term}%", "%#{term}%"],
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

    end

    @comedies = Play.find_all_by_classification('Comedy')
    @histories = Play.find_all_by_classification('History')
    @tragedies = Play.find_all_by_classification('Tragedy')

    render :partial => 'search', :layout => false

  end

  def men
    @monologues = Monologue.find_all_by_name('Men')
    @comedies = Play.find_all_by_classification('Comedy')
    @histories = Play.find_all_by_classification('History')
    @tragedies = Play.find_all_by_classification('Tragedy')
    render :index
  end

  def women
    @monologues = Monologue.find_all_by_name('Women')
    @comedies = Play.find_all_by_classification('Comedy')
    @histories = Play.find_all_by_classification('History')
    @tragedies = Play.find_all_by_classification('Tragedy')
    render :index
  end

end
