# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_routes_session',
  :secret      => 'e69287edfb0c087dee55ae37c6fd55f04bb4263ae0346a8ec4990d76ca97fbedee51086544e2b22d0000fb6fadc494c9d3b3b06d1afbfbdbf6c535abb9acb74d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
