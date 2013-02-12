require 'sinatra/base'

require './helpers/application_helper'
require './controllers/application_controller'
require './controllers/authentication_controller'
require './controllers/resources_controller'

map('/') { run ApplicationController }
map('/authenticate') { run AuthenticationController }
map('/resources') { run ResourcesController }