class Admin::PlaysController < ApplicationController


  # GET /plays
  # GET /plays.xml
  def index
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @plays = Play.all
    @comedies = Play.find_all_by_classification('Comedy')
    @histories = Play.find_all_by_classification('History')
    @tragedies = Play.find_all_by_classification('Tragedy')
    
    respond_to do |format|
      format.html { render :index, :layout => 'admin' }
      format.xml  { render :xml => @plays }
    end
  end

  # GET /plays/1
  # GET /plays/1.xml
  def show
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @play = Play.find(params[:id])
    @play_id = @play.id
    if params[:g]
      @gender = GENDER[ params[:g] ]
      @both_gender = GENDER['Both']
      @other_gender = @gender.name.match(/^Men$/) ? GENDER['Women'] : GENDER['Men']
      @monologues = Monologue.find(
        :all,
        :conditions =>
          ['(gender_id = ? OR gender_id = ?) AND play_id = ?', @gender.id, @both_gender.id, @play.id]
      )
    else
      @gender = nil
      @monologues = @play.monologues
    end

    respond_to do |format|
      format.html { render :show, :layout => 'admin' }
      format.xml  { render :xml => @play }
    end
  end

end
