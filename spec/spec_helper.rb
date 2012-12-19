require './resources_app'
require 'rspec'
require 'rack/test'

set :environment, :test
set :run, false
set :raise_errors, true

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end