require 'rspec'
require 'rack/test'

require File.expand_path '../../helpers/application_helper.rb', __FILE__
require File.expand_path '../../controllers/application_controller.rb', __FILE__
require File.expand_path '../../controllers/resources_controller.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app
    described_class
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
end
