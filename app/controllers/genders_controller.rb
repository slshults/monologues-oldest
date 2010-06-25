class GendersController < ApplicationController

  COMEDIES = Play.find_all_by_classification('Comedy')
  HISTORIES = Play.find_all_by_classification('History')
  TRAGEDIES = Play.find_all_by_classification('Tragedy')

  # map gender id to gender, AND gender name to object
  GENDER = Hash.new
  Gender.all.map{|g| GENDER[g.id.to_s] = g}
  Gender.all.map{|g| GENDER[g.name] = g}

  # GET /genders
  # GET /genders.xml
  def index
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @genders = Gender.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @genders }
    end
  end

  def men
    @gender = GENDER[ 'Men' ]
    @comedies = COMEDIES
    @histories = HISTORIES
    @tragedies = TRAGEDIES
    @other_gender = Gender.find_by_name('Women')
    render :show
  end

  def women
    @gender = GENDER[ 'Women' ]
    @comedies = COMEDIES
    @histories = HISTORIES
    @tragedies = TRAGEDIES
    @other_gender = Gender.find_by_name('Men')
    render :show
  end

  # GET /genders/1
  # GET /genders/1.xml
  def show
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @gender = GENDER[ params[:id] ]

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gender }
    end
  end

  # GET /genders/new
  # GET /genders/new.xml
  def new
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @gender = Gender.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gender }
    end
  end

  # GET /genders/1/edit
  def edit
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @gender = GENDER[ params[:id] ]
  end

  # POST /genders
  # POST /genders.xml
  def create
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @gender = GENDER[ params[:gender] ]

    respond_to do |format|
      if @gender.save
        flash[:notice] = 'Gender was successfully created.'
        format.html { redirect_to(@gender) }
        format.xml  { render :xml => @gender, :status => :created, :location => @gender }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gender.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /genders/1
  # PUT /genders/1.xml
  def update
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @gender = GENDER[ params[:id] ]

    respond_to do |format|
      if @gender.update_attributes(params[:gender])
        flash[:notice] = 'Gender was successfully updated.'
        format.html { redirect_to(@gender) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gender.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /genders/1
  # DELETE /genders/1.xml
  def destroy
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @gender = GENDER[ params[:id] ]
    @gender.destroy

    respond_to do |format|
      format.html { redirect_to(genders_url) }
      format.xml  { head :ok }
    end
  end
end
