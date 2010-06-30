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

  namespace :mono do

    desc "Clear Monologue file cache on server"
    task :clearcache, :roles => :app, :except => { :no_release => true } do
      run "rm -r  #{current_path}/tmp/cache/views/"
    end

    desc "Backup the current Monologue db"
    task :backupdb, :roles => :app, :except => { :no_release => true } do
      date = Time.now.strftime("%Y_%m_%d")
      run "cp #{current_path}/db/production.sqlite3 #{deploy_to}/db_backups/#{date}_production.sqlite3"
    end

  end

end