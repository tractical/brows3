require './spec/spec_helper'

describe "ApplicationController" do

  describe 'GET /' do
    it 'renders the page' do
      get '/'
      last_response.should be_ok
    end
  end
end
