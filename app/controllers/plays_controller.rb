class PlaysController < ApplicationController
  # GET /plays
  # GET /plays.xml
  def index
    @plays = Play.all
    @comedies = Play.find_all_by_classification('Comedy')
    @histories = Play.find_all_by_classification('History')
    @tragedies = Play.find_all_by_classification('Tragedy')

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
      @gender = Gender.find_by_id(params[:g])
      other_gender_id = @gender.id == 2 ? 3 : 2
      @other_gender = Gender.find_by_id( other_gender_id )
      @monologues = Monologue.find_all_by_gender_id_and_play_id(@gender.id, @play.id)
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
      format.html { render :new }
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
  end

  # POST /plays
  # POST /plays.xml
  def create
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
