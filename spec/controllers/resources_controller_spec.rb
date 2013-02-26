require './spec/spec_helper'

describe "ResourcesController" do

  subject do
    Fog::Storage::AWS.new(aws_access_key_id: 'abcdef', aws_secret_access_key: 'secret')
  end

  before :all do
    directory = subject.directories.create(key: 'resources.bucket')
    file = directory.files.create(key: 'ebooks/book.epub', body: 'my book')
    file.save
  end

  describe '/' do
    before do
      get '/'
    end

    it 'responds with success' do
      last_response.should be_ok
    end

    it 'connects to S3' do
      subject.should be
    end
  end

  describe '/buckets' do
    before do
      get '/buckets'
    end

    it 'responds with success' do
      last_response.should be_ok
    end

    it 'returns a list of buckets' do
      subject.directories.should_not be_empty
    end
  end

  # describe '/bucket/:id/?' do
  #   before do
  #     get "/bucket/#{subject.directories.first.key}/"
  #   end

  #   it 'responds with success' do
  #     last_response.should be_ok
  #   end

  #   it 'gets directories under that bucket' do
  #     subject.directories.get(subject.directories.first.key).should be
  #   end
  # end
end