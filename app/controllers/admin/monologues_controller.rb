require 'vendor/plugins/active_record_extensions'
class Admin::MonologuesController < ApplicationController

  COMEDIES = Play.find_all_by_classification('Comedy')
  HISTORIES = Play.find_all_by_classification('History')
  TRAGEDIES = Play.find_all_by_classification('Tragedy')

  # map gender id to gender, AND gender name to object
  GENDER = Hash.new
  Gender.all.map{|g| GENDER[g.id.to_s] = g}
  Gender.all.map{|g| GENDER[g.name] = g}

  def index
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @comedies = COMEDIES
    @histories = HISTORIES
    @tragedies = TRAGEDIES
    @monologues = Monologue.all
    render :index, :layout => 'admin'
  end
  
  def show
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @monologue = Monologue.find(params[:id])
    render :show, :layout => 'admin'
  end

end
