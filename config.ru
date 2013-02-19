require 'sinatra/base'

require './helpers/application_helper'
require './helpers/resources_helper'
require './controllers/application_controller'
require './controllers/resources_controller'

map('/') { run ApplicationController }
map('/resources') { run ResourcesController }