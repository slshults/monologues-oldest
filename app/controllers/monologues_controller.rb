require 'vendor/plugins/active_record_extensions'
class MonologuesController < ApplicationController
  def index
    @monologues = Monologue.paginate :page => params[:page], :per_page => 20
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
    @plays = Play.all
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
    @ajax_search = params[:search]
    unless @ajax_search.blank?
      @terms = @ajax_search.split(" ")
      @monologues = []
      @terms.each do |term|
        case ActiveRecord::Base.connection.adapter_name
        when 'SQLite'
          where_clause = "character like '%#{term}%' or body like '%#{term}%' or first_line like '%#{term}%'"
        when 'PostgreSQL'
          where_clause =  "character ilike '%#{term}%' or body ilike '%#{term}%' or first_line ilike '%#{term}%'"
        else
          raise 'Query not implemented for DB adapter: ' + ActiveRecord::Base.connection.adapter_name
        end
        results = Monologue.find(:all, :conditions => where_clause)
        @monologues = results if results and @monologues.empty?
        @monologues &= results if results
      end
      @monologues.compact!
      @monologues.uniq!
      @monologues = @monologues.paginate :search => @ajax_search, :page => params[:page], :per_page => 10
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
