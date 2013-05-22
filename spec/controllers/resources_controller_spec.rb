require './spec/spec_helper'

describe ResourcesController do

  let(:s3)     { double(AWS::S3).as_null_object }
  let(:bucket) { double(AWS::S3::Bucket).as_null_object }
  let(:bucket_collection) { double(AWS::S3::BucketCollection).as_null_object }
  let(:bucket_tree) { double(AWS::S3::Tree).as_null_object }

  before do
    s3.stub_chain(:buckets, :first, :name)
    AWS::S3.stub(:new).and_return(s3)
  end

  describe "GET /" do
    it "responds with redirect" do
      get "/"
      last_response.should be_redirect
    end
  end

  describe "GET /buckets" do
    before do
      s3.stub(:buckets).and_return([bucket])
    end

    it "gets s3 buckets" do
      s3.should_receive(:buckets)
      get "/buckets/"
    end

    it "renders the page" do
      get "/buckets/"
      last_response.should be_ok
    end
  end

  describe "GET /buckets/:bucket_id/" do
    before do
      s3.stub(:buckets).and_return(bucket_collection)
    end

    it "gets bucket with :bucket_id" do
      bucket_collection.should_receive(:[]).with("bucket_name")

      get "/buckets/bucket_name/"
    end

    it "renders the page" do
      get "/buckets/bucket_name/"
      last_response.should be_ok
    end
  end
end
