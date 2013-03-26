require 'aws-sdk'

class ResourcesController < ApplicationController

  before do
    validate_credentials unless session[:logged_in]

    aws_access_key = session[:aws_access]
    aws_secret_key = session[:aws_secret]

    @storage ||= AWS::S3.new(access_key_id: aws_access_key, secret_access_key: aws_secret_key)
  end

  get '/' do
    redirect to '/buckets/'
  end

  # buckets#index
  get '/buckets/?' do
    @buckets = @storage.buckets
    erb :'resources/buckets/index', layout: :resources
  end

  # buckets#show
  get '/buckets/:bucket_id/' do
    @bucket = @storage.buckets[params[:bucket_id]]

    @directories = @bucket.as_tree.children.select(&:branch?).collect(&:prefix)
    @files = @bucket.as_tree.children.select(&:leaf?).reject { |f| f.key == prefix }

    erb :'resources/buckets/show', layout: :resources
  end

  # files#index
  get '/buckets/:bucket_id/*/' do
    @bucket = @storage.buckets[params[:bucket_id]]

    prefix = params[:splat].first.gsub(/\/+$/, '') + '/'
    tree = @bucket.as_tree(prefix: prefix)
    @directories = tree.children.select(&:branch?)
    @files = tree.children.select(&:leaf?).reject { |f| f.key == prefix }

    erb :'resources/files/index', layout: :resources
  end

end