require './spec/spec_helper'

describe ApplicationController do

  describe "GET /" do
    it 'renders the page' do
      get "/"
      last_response.should be_ok
    end
  end

  %w(faq terms privacy login).each do |page|
    describe "GET /#{page}" do
      it 'renders the page' do
        get "/#{page}/"
        last_response.should be_ok
      end
    end
  end

  describe "GET %r{(\/.*[^\/])$}" do
    it "redirects to url with trailing '/'" do
      get "/faq" do
        last_response.should be_redirect
        follow_redirect!
        last_request.path.should == "/faq/"
      end
    end
  end

  describe "GET /logout" do

    before do
      get "/logout/"
    end

    it "clears session" do
      last_response.should be_redirect
      follow_redirect!
      last_response.should be_ok
    end

    it "sets alert message" do
      last_response.should be_redirect
      follow_redirect!
      last_response.body.should include("You have logged out.")
    end
  end

  describe "POST /login" do
    let(:s3) { double("AWS::S3") }

    it "receives params" do
      AWS::S3.should_receive(:new)
        .with(access_key_id: "access", secret_access_key: "secret")
        .and_return(s3)
      s3.stub_chain(:buckets, :first, :name).and_return "Bucket"
      post "/login", { aws_access: "access", aws_secret: "secret" }
    end

    context "when successful" do
      before do
        AWS::S3.stub(:new).and_return s3
        s3.stub_chain(:buckets, :first, :name).and_return "Bucket"
        post "/login", { aws_access: "access", aws_secret: "secret" }
      end

      it "redirects to /resources/buckets" do
        last_response.should be_redirect
        follow_redirect!
        last_request.path.should == "/resources/buckets/"
      end
    end

    context "when unsuccessful" do
      before do
        AWS::S3.stub(:new).and_return s3
        s3.stub(:buckets).and_raise ArgumentError
        post "/login", { aws_access: "access", aws_secret: "secret" }
      end

      it "redirects to home" do
        last_response.should be_redirect
        follow_redirect!
        last_request.path.should == "/"
      end

      it "sets flash notice message" do
        last_response.should be_redirect
        follow_redirect!
        last_request.env["x-rack.flash"].should_not be_nil
      end
    end
  end
end
