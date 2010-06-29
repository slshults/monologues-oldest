require 'vendor/plugins/active_record_extensions'
class Admin::MonologuesController < ApplicationController

  def index
    unless logged_in?
      redirect_to new_login_url
      return
    end
    @comedies = Play.find_all_by_classification('Comedy')
    @histories = Play.find_all_by_classification('History')
    @tragedies = Play.find_all_by_classification('Tragedy')
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
