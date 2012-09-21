require "./resources_app"
require "rspec"
require "rack/test"

# ENV['RACK_ENV'] = 'test'
set :environment, :test


RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end