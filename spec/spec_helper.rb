ENV["RACK_ENV"] = "test"

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :assets, :test)

require File.expand_path('../../helpers/application_helper.rb', __FILE__)
require File.expand_path('../../controllers/application_controller.rb', __FILE__)
require File.expand_path('../../controllers/resources_controller.rb', __FILE__)

module RSpecMixin
  include Rack::Test::Methods

  def app
    described_class
  end

  Sprockets::Helpers.configure do |config|
    config.environment = Sprockets::Environment.new
  end

end

RSpec.configure do |config|
  config.include RSpecMixin

  config.color = true
end
