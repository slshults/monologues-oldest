ActionController::Routing::Routes.draw do |map|
  map.resources :monologues
  
  map.resources :genders

  map.resources :plays

  map.resources :authors

  map.resources :users

  map.resources :logins

  map.connect '/logout', :controller => 'logins', :action => 'destroy'

  # Men
  men = Gender.find_by_name('Men')
  # Women
  women = Gender.find_by_name('Women')

  map.connect '/men', :controller => :genders, :action => 'men', :id => men.id
  map.connect '/women', :controller => :genders, :action => 'women', :id => women.id

  # Hamlet
  play = Play.find_by_title('Hamlet')
  map.connect '/hamlet', :controller => 'plays', :action => 'show', :id => play.id
  map.connect '/men/hamlet', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
  map.connect '/women/hamlet', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

#  # A Midsummer Nights Dream
#  play = Play.find_by_title('A Midsummer Nights Dream')
#  map.connect '/midsummer', :controller => 'plays', :action => 'show', :id => play.id
#  map.connect '/men/midsummer', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
#  map.connect '/women/midsummer', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

  
  # Leave the following at the bottom of this file
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.root :controller => 'monologues'

end
