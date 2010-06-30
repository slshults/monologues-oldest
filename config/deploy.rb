set :application, "Monologues"
set :domain, "freeinternet.org"
set :user, "freeinte"
set :repository,  "git://github.com/bfaloona/monologues.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"
set :deploy_to, "/home/freeinte/mono"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache

role :app, domain
role :web, domain
role :db,  domain, :primary => true

# Necessary to run on Site5
set :use_sudo, false
set :group_writable, false

task :set_permissions do
  donothing = true
end
