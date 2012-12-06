require './spec/spec_helper'
require 'debugger'

describe "ResourcesApp" do

  def app
    Sinatra::Application
  end

  subject do
    Fog.mock!
    storage = Fog::Storage::AWS.new(aws_access_key_id: 'abcdef', aws_secret_access_key: 'secret')
  end

  describe '/' do
    it 'connects to S3' do
      get '/'
      subject.should be
    end
  end

  describe '/buckets' do
    before do
      subject.put_bucket 'resource.bucket'
    end

    it 'returns a list of buckets' do
      get '/buckets'
      subject.directories.should_not be_empty
    end
  end
end