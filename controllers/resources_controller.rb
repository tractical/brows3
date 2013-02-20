require 'fog'
require 'tree'

class ResourcesController < ApplicationController
  helpers ResourcesHelper

  before do
    validate_credentials unless session[:logged_in]

    aws_access_key = session[:aws_access]
    aws_secret_key = session[:aws_secret]

    @storage ||= Fog::Storage::AWS.new(aws_access_key_id: aws_access_key, aws_secret_access_key: aws_secret_key)
  end

  get '/' do
    erb :'resources/index'
  end

  # buckets#index
  get '/buckets' do
    @buckets = @storage.directories
    erb :'resources/buckets/index'
  end

  # buckets#show
  get '/bucket/:bucket_id/?' do
    bucket = @storage.directories.get(params[:bucket_id])

    @directories = tree_from_bucket(bucket).children.select { |node| node.has_children? || node.content.key.end_with?('/') }
    @files = tree_from_bucket(bucket).children.select { |node| node.is_leaf? && !node.content.key.end_with?('/') }

    erb :'resources/buckets/show'
  end

  # files#index
  get '/bucket/:bucket_id/*/?' do
    bucket = @storage.directories.get(params[:bucket_id])

    path = params[:splat].first.split('/')
    node = tree_from_bucket(bucket).find { |node| node.name == path.last }
    children_nodes = node.try(:children)

    @directories = children_nodes.try(:select) { |node| node.has_children? || node.content.key.end_with?('/') }
    @files = children_nodes.try(:select) { |node| node.is_leaf? && !node.content.key.end_with?('/') }
    @file = node

    erb :'resources/files/index'
  end

end