require './spec/spec_helper'

describe "ResourcesApp" do

  def app
    Sinatra::Application
  end

  describe "/resources" do
    before do
      get "/resources"
    end

    it "responds with success" do
      last_response.should be_ok
    end

    it "returns S3 directories and files" do
      last_response.body.should include "Directories"
    end
  end

end