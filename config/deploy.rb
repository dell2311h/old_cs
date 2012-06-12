set :application, "crowdsync" # Name of application
set :repository,  "git@git.111min.com:cs_server.git"

set :rvm_ruby_string, "1.9.2-p290@#{application}"
set :rvm_type, :system

set :default_stage, "staging"
set :stages, %w(staging)

set :keep_releases, 1

require "rvm/capistrano"
require 'capistrano/ext/multistage'
require "bundler/capistrano"

