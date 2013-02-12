require 'sinatra/base'

require './helpers/application_helper.rb'
require './controllers/application_controller.rb'
require './controllers/authentication_controller.rb'
require './controllers/resources_controller.rb'

map('/') { run ApplicationController }
map('/authenticate') { run AuthenticationController }
map('/resources') { run ResourcesController }