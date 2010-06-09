ActionController::Routing::Routes.draw do |map|
  map.resources :monologues
  
  map.resources :genders

  map.resources :plays

  map.resources :authors

  map.resources :users

  map.resources :logins

  map.connect '/logout', :controller => 'logins', :action => 'destroy'


  map.connect '/men', :controller => :genders, :action => 'men', :id => 3
  map.connect '/women', :controller => :genders, :action => 'women', :id => 2

  # Hamlet
  map.connect '/hamlet', :controller => 'plays', :action => 'show', :id => 31
  map.connect '/men/hamlet', :controller => 'plays', :action => 'show', :id => 31, :g => 3
  map.connect '/women/hamlet', :controller => 'plays', :action => 'show', :id => 31, :g => 2


  
  # Leave the following at the bottom of this file
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.root :controller => 'monologues'

end
