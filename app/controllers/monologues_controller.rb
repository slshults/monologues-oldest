class MonologuesController < ApplicationController
  # GET /monologues
  # GET /monologues.xml
  def index
    @monologues = Monologue.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @monologues }
    end
  end

  # GET /monologues/1
  # GET /monologues/1.xml
  def show
    @monologue = Monologue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @monologue }
    end
  end

  # GET /monologues/new
  # GET /monologues/new.xml
  def new
    @monologue = Monologue.new
    @plays = Play.all
    @genders = Gender.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @monologue }
    end
  end

  # GET /monologues/1/edit
  def edit
    @monologue = Monologue.find(params[:id])
    @plays = Play.all
    @genders = Gender.all
    
  end

  # POST /monologues
  # POST /monologues.xml
  def create
    @monologue = Monologue.new(params[:monologue])

    respond_to do |format|
      if @monologue.save
        flash[:notice] = 'Monologue was successfully created.'
        format.html { redirect_to(@monologue) }
        format.xml  { render :xml => @monologue, :status => :created, :location => @monologue }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @monologue.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /monologues/1
  # PUT /monologues/1.xml
  def update
    @monologue = Monologue.find(params[:id])

    respond_to do |format|
      if @monologue.update_attributes(params[:monologue])
        flash[:notice] = 'Monologue was successfully updated.'
        format.html { redirect_to(@monologue) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @monologue.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /monologues/1
  # DELETE /monologues/1.xml
  def destroy
    @monologue = Monologue.find(params[:id])
    @monologue.destroy

    respond_to do |format|
      format.html { redirect_to(monologues_url) }
      format.xml  { head :ok }
    end
  end
end
