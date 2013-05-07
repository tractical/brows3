require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :assets)

require './helpers/application_helper'
require './controllers/application_controller'
require './controllers/resources_controller'

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'assets/javascripts'
  environment.append_path 'assets/stylesheets'
  environment.append_path 'assets/images'

  Sprockets::Helpers.configure do |config|
    config.environment = environment
    config.prefix      = "/assets"
    config.digest      = false
  end

  run environment
end

map('/') { run ApplicationController }
map('/resources') { run ResourcesController }
