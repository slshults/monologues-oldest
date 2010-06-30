set :application, "Monologues"
set :domain, "freeinternet.org"
set :user, "freeinte"
set :repository,  "git://github.com/bfaloona/monologues.git"

set :deploy_to, "/home/freeinte/mono"

set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache

role :app, domain
role :web, domain
role :db,  domain, :primary => true

# Necessary to run on Site5
set :use_sudo, false
set :group_writable, false

desc "Site5 best practice is that set_permissions is a no-op"
task :set_permissions do
  donothing = true
end

# Passenger customized tasks
namespace :deploy do
  desc "Restarting mod_rails (Passenger) with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails (Passenger)"
    task t, :roles => :app do ; end
  end
end