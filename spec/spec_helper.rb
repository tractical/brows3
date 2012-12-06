require './resources_app'
require 'rspec'
require 'rack/test'

set :environment, :test

RSpec.configure do |config|
  config.include Rack::Test::Methods
end