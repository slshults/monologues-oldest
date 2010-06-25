class PlaysController < ApplicationController

  COMEDIES = Play.find_all_by_classification('Comedy')
  HISTORIES = Play.find_all_by_classification('History')
  TRAGEDIES = Play.find_all_by_classification('Tragedy')

  # map gender id to gender, AND gender name to object
  GENDER = Hash.new
  Gender.all.map{|g| GENDER[g.id] = g}
  Gender.all.map{|g| GENDER[g.id.to_s] = g}
  Gender.all.map{|g| GENDER[g.name] = g}

  caches_page :index
  
  # GET /plays
  # GET /plays.xml
  def index
    @plays = Play.all
    @comedies = COMEDIES
    @histories = HISTORIES
    @tragedies = TRAGEDIES
    
    respond_to do |format|
      format.html { render :index }
      format.xml  { render :xml => @plays }
    end
  end

  # GET /plays/1
  # GET /plays/1.xml
  def show
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
      format.html { render :show }
      format.xml  { render :xml => @play }
    end
  end

  # GET /plays/new
  # GET /plays/new.xml
  def new
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @play = Play.new

    respond_to do |format|
      format.html { render :new, :layout => 'admin' }
      format.xml  { render :xml => @play }
    end
  end

  # GET /plays/1/edit
  def edit
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @play = Play.find(params[:id])
    render :edit, :layout => 'admin'
  end


  # POST /plays
  # POST /plays.xml
  def create
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @play = Play.new(params[:play])

    respond_to do |format|
      if @play.save
        flash[:notice] = 'Play was successfully created.'
        format.html { redirect_to(@play) }
        format.xml  { render :xml => @play, :status => :created, :location => @play }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @play.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /plays/1
  # PUT /plays/1.xml
  def update
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @play = Play.find(params[:id])

    respond_to do |format|
      if @play.update_attributes(params[:play])
        flash[:notice] = 'Play was successfully updated.'
        format.html { redirect_to(@play) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @play.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /plays/1
  # DELETE /plays/1.xml
  def destroy
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @play = Play.find(params[:id])
    @play.destroy

    respond_to do |format|
      format.html { redirect_to(plays_url) }
      format.xml  { head :ok }
    end
  end
end
