require 'rubygems'
require 'bundler/setup'

Bundler.require(:default, :assets)

require './helpers/application_helper'
require './controllers/application_controller'
require './controllers/resources_controller'

map('/') { run ApplicationController }
map('/resources') { run ResourcesController }
