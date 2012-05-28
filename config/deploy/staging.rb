set :application, "crowdsync" # Name of application
set :repository,  "git@github.com:111minutes/cs-server.git"
set :branch, "master"

default_run_options[:pty] = true  # Must be set for the password prompt from git to work

set :scm, "git" # Source Code Management system
set :git_enable_submodules, true

set :user, "crowdsync"  # The server's user for deploys
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache # In most cases you want to use this option, otherwise each deploy will do a full repository clone every time.

# If you’re using your own private keys for git you might want to tell Capistrano to use agent forwarding with this command. Agent forwarding can make key management much simpler as it uses your local keys instead of keys installed on the server.

ssh_options[:forward_agent] = true

set :use_sudo, false

# Deployment server
server "#{application}.dimalexsoftware.com", :app, :web, :db, :primary => true

# Rails environment
set :rails_env, "production"

namespace :deploy do

  desc "Start application"
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && bundle exec unicorn -E #{rails_env} -c config/unicorn.conf.rb -D"
  end

  desc "Stop application"
  task :stop, :roles => :app, :except => { :no_release => true }  do
    run "cd #{current_path} && kill -QUIT `cat tmp/pids/unicorn.pid`"
  end

  desc "Restart application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && kill -s USR2 `cat tmp/pids/unicorn.pid`"
  end

  desc "Create additional symlinks"
  task :symlink_configs, :role => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
    run "ln -nfs #{shared_path}/config/application.yml #{latest_release}/config/application.yml"
    run "ln -nfs #{shared_path}/config/unicorn.conf #{latest_release}/config/unicorn.conf"
    run "ln -nfs #{shared_path}/config/initializers/carrierwave.rb #{latest_release}/config/initializers/carrierwave.rb"
    run "ln -nfs #{shared_path}/config/environments/#{rails_env}.rb #{latest_release}/config/environments/#{rails_env}.rb"
  end

  desc "Run resque"
  task :run_resque, :roles => :app do
    run "cd #{release_path} && RAILS_ENV=#{rails_env} rake resque:restart"
  end

end

desc "View logs in real time"
namespace :logs do

  task :application do
    stream("cd #{current_path} && tail -f log/#{rails_env}.log")
  end

end

after "deploy:update_code", "deploy:symlink_configs"
after "deploy:symlink_configs", "deploy:run_resque"

