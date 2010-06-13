ActionController::Routing::Routes.draw do |map|
  map.resources :monologues
  
  map.resources :genders

  map.resources :plays

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
    play = Play.find_by_title('A Midsummer Nights Dream')
    map.connect '/midsummer', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/midsummer', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/midsummer', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # All's Well That Ends Well
    play = Play.find_by_title('Alls Well That Ends Well')
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
    play = Play.find_by_title('Loves Labours Lost')
    map.connect '/LLL', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/LLL', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/LLL', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Measure for Measure
    play = Play.find_by_title('Measure for Measure')
    map.connect '/Measure', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/Measure', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/Measure', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # The Merry Wives of Windsor
    play = Play.find_by_title('The Merry Wives of Windsor')
    map.connect '/TMWoW', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/TMWoW', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/TMWoW', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

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

    # Pericles, Prince of Tyre
    play = Play.find_by_title('Pericles, Prince of Tyre')
    map.connect '/pericles', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/pericles', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/pericles', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # The Taming of the Shrew
    play = Play.find_by_title('The Taming of the Shrew')
    map.connect '/shrew', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/shrew', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/shrew', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # The Tempest
    play = Play.find_by_title('The Tempest')
    map.connect '/tempest', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/tempest', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/tempest', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Troilus and Cressida
    play = Play.find_by_title('Troilus and Cressida')
    map.connect '/troilus', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/troilus', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/troilus', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Twelfth Night, Or What You Will
    play = Play.find_by_title('Twelfth Night, Or What You Will')
    map.connect '/12thNight', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/12thNight', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/12thNight', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # The Two Gentlemen of Verona
    play = Play.find_by_title('The Two Gentlemen of Verona')
    map.connect '/TwoGents', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/TwoGents', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/TwoGents', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Winter's Tale
    play = Play.find_by_title('Winters Tale')
    map.connect '/WintersTale', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/WintersTale', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/WintersTale', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Henry IV, Part 1
    play = Play.find_by_title('Henry IV, Part 1')
    map.connect '/HenryIVi', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/HenryIVi', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/HenryIVi', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Henry IV, Part 1
    play = Play.find_by_title('Henry IV, Part 2')
    map.connect '/HenryIVii', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/HenryIVii', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/HenryIVii', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Henry V
    play = Play.find_by_title('Henry V')
    map.connect '/HenryV', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/HenryV', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/HenryV', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Henry VI, Part 1
    play = Play.find_by_title('Henry VI, Part 1')
    map.connect '/HenryVIi', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/HenryVIi', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/HenryVIi', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Henry VI, Part 2
    play = Play.find_by_title('Henry VI, Part 2')
    map.connect '/HenryVIii', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/HenryVIii', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/HenryVIii', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Henry VI, Part 3
    play = Play.find_by_title('Henry VI, Part 3')
    map.connect '/HenryVIiii', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/HenryVIiii', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/HenryVIiii', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Henry VIII
    play = Play.find_by_title('Henry VIII')
    map.connect '/HenryVIII', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/HenryVIII', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/HenryVIII', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # King John
    play = Play.find_by_title('King John')
    map.connect '/KingJohn', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/KingJohn', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/KingJohn', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Richard II
    play = Play.find_by_title('Richard II')
    map.connect '/RichardII', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/RichardII', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/RichardII', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Richard III
    play = Play.find_by_title('Richard III')
    map.connect '/RichardIII', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/RichardIII', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/RichardIII', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Antony and Cleopatra
    play = Play.find_by_title('Antony and Cleopatra')
    map.connect '/AandC', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/AandC', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/AandC', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Coriolanus
    play = Play.find_by_title('Coriolanus')
    map.connect '/coriolanus', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/coriolanus', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/coriolanus', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Julius Caesar
    play = Play.find_by_title('Julius Caesar')
    map.connect '/caesar', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/caesar', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/caesar', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # King Lear
    play = Play.find_by_title('King Lear')
    map.connect '/lear', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/lear', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/lear', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

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

    # Timon of Athens
    play = Play.find_by_title('Timon of Athens')
    map.connect '/TofA', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/TofA', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/TofA', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id

    # Titus Andronicus
    play = Play.find_by_title('Titus Andronicus')
    map.connect '/titus', :controller => 'plays', :action => 'show', :id => play.id
    map.connect '/men/titus', :controller => 'plays', :action => 'show', :id => play.id, :g => men.id
    map.connect '/women/titus', :controller => 'plays', :action => 'show', :id => play.id, :g => women.id


  end
  
  # Leave the following at the bottom of this file
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.root :controller => 'monologues'

end
