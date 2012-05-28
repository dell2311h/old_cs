set :default_stage, "staging"
set :stages, %w(staging production)
require 'capistrano/ext/multistage'

