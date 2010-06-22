ActionController::Routing::Routes.draw do |map|


  map.resources :monologues

  map.resources :adminmono, :controller => 'admin/monologues'
#  map.resources :admin do |admin|
#    admin.resources :monologues
#  end
  
  map.resources :genders

  map.resources :plays

  map.resources :adminplays, :controller => 'admin/plays'

  map.resources :authors

  map.resources :users

  map.resources :logins

  map.connect '/logout', :controller => 'logins', :action => 'destroy'

  unless RAILS_ENV['test']
    men = Gender.find_by_name('Men')
    women = Gender.find_by_name('Women')
    map.connect '/men', :controller => :genders, :action => 'men', :id => men.id
    map.connect '/women', :controller => :genders, :action => 'women', :id => women.id

    # Hamlet
    play = Play.find_by_title('Hamlet')
    map.connect '/hamlet', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/hamlet', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/hamlet', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # A Midsummer Night's Dream
    play = Play.find_by_title('A Midsummer Night\'s Dream')
    map.connect '/midsummer', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/midsummer', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/midsummer', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # All's Well That Ends Well
    play = Play.find_by_title('All\'s Well That Ends Well')
    map.connect '/AllsWell', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/AllsWell', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/AllsWell', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id


    # As You Like It
    play = Play.find_by_title('As You Like It')
    map.connect '/AsYouLikeIt', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/AsYouLikeIt', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/AsYouLikeIt', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # The Comedy of Errors
    play = Play.find_by_title('The Comedy of Errors')
    map.connect '/Errors', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/Errors', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/Errors', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Cymbeline
    play = Play.find_by_title('Cymbeline')
    map.connect '/Cymbeline', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/Cymbeline', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/Cymbeline', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Love's Labours Lost
    play = Play.find_by_title('Love\'s Labours Lost')
    map.connect '/LLL', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/LLL', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/LLL', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # The Merchant of Venice
    play = Play.find_by_title('The Merchant of Venice')
    map.connect '/merchant', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/merchant', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/TMoV', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Much Ado About Nothing
    play = Play.find_by_title('Much Ado About Nothing')
    map.connect '/MuchAdo', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/MuchAdo', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/MuchAdo', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Twelfth Night, Or What You Will
    play = Play.find_by_title('Twelfth Night, Or What You Will')
    map.connect '/12thNight', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/12thNight', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/12thNight', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Henry IV, Part 1
    play = Play.find_by_title('Henry IV i')
    map.connect '/HenryIVi', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/HenryIVi', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/HenryIVi', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Antony and Cleopatra
    play = Play.find_by_title('Antony & Cleopatra')
    map.connect '/AandC', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/AandC', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/AandC', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Macbeth
    play = Play.find_by_title('Macbeth')
    map.connect '/macbeth', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/macbeth', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/macbeth', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Othello
    play = Play.find_by_title('Othello')
    map.connect '/othello', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/othello', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/othello', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Romeo and Juliet
    play = Play.find_by_title('Romeo and Juliet')
    map.connect '/RandJ', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/RandJ', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/RandJ', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id


  end
  
  # Leave the following at the bottom of this file
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.root :controller => 'monologues'

end
