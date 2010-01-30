# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mono_session',
  :secret      => '3a66ea00ca48fd60d959ef603fd2b8ff6a74d52b59a045c8d92cfc7f838b2e3802e600d59018082f2adab13b5b470aabb6fa5e6af3c682b47755555e0b2abda0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
