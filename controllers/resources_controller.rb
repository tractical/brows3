require 'fog'
require 'tree'
require 'debugger'

class ResourcesController < ApplicationController
  helpers ResourcesHelper

  before do
    aws_access_key = session[:aws_access]
    aws_secret_key = session[:aws_secret]
    @storage ||= Fog::Storage::AWS.new(aws_access_key_id: aws_access_key, aws_secret_access_key: aws_secret_key)
  end

  get '/' do
    erb :'resources/index'
  end

  post '/login' do
    session[:aws_access] = params[:aws_access].empty? ? nil : params[:aws_access]
    session[:aws_secret] = params[:aws_secret].empty? ? nil : params[:aws_secret]
    redirect '/resources'
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

  # directories#edit
  get '/bucket/:bucket_id/*/edit' do
    bucket = @storage.directories.get(params[:bucket_id])
    if @file = bucket.files.get(params[:splat].first + "/")
      erb :'resources/directories/edit'
    else
      erb :not_found
    end
  end

  # directories#update
  # 1. Copy file with new parameteres first.
  # 2. Copy children files into new copied file (directory).
  # 3. Destroy all directory and children files.
  put '/bucket/:bucket_id/*/?' do
    bucket = @storage.directories.get(params[:bucket_id])
    splat = params[:splat].first.gsub(/\/$/, '') + "/"

    if file = bucket.files.get(splat)
      child_files = bucket.files.all(prefix: splat)

      if file.key.split('/').last != params[:name]
        # Copy files and directory with new name.
        new_name = params[:name].gsub(/\/$/, '') + "/"
        new_name = file.key.gsub(/([^\/]*)\/$/, new_name)

        new_file = file.copy(params[:bucket_id], new_name) unless params[:name].empty?
        child_files.each do |cf|
          next if cf.key == splat

          new_cf = cf.copy(params[:bucket_id], cf.key.gsub(splat, new_file.key))
          cf.destroy
        end

        file.destroy
      end
    else
      halt 500
    end

    redirect "/resources/bucket/#{bucket.key}/"
  end

  # directories#destroy
  # Delete files inside the folder first, the folder last.
  delete '/bucket/:bucket_id/*/?' do
    bucket = @storage.directories.get(params[:bucket_id])
    splat = params[:splat].first.gsub(/\/$/, '') + "/"

    if file = bucket.files.get(splat)
      bucket.files.all(prefix: splat).each do |cf|
        cf.destroy
      end

      file.destroy
      parent = tree_from_bucket(bucket).find { |node| node.name == splat.split('/')[-2] }
      node = tree_from_bucket(bucket).find { |node| node.name == splat.split('/').last }
      parent.remove!(node)
    else
      halt 500
    end

    redirect "/resources/bucket/#{bucket.key}/#{splat.split('/')[-2]}/"
  end

  get '/bucket/:bucket_id/*/directories/new' do
    @path = [params[:bucket_id], params[:splat].first].join('/') + "/"
    erb :'resources/directories/new'
  end

  # directories#create
  # Create a directory at the given path
  # Note: Need to create a blank temporary file inside so that the resource
  # is treated as a directory.
  post '/bucket/:bucket_id/*/directories/?' do
    bucket = @storage.directories.get(params[:bucket_id])
    path = params[:splat].first + "/"
    name = path + params[:name].gsub(/\//, '') + '/'

    if file = bucket.files.create(key: name)
      parent = tree_from_bucket(bucket).find { |node| node.name == path.split('/').last }
      parent.add(Tree::TreeNode.new(name.split('/').last, file))
      redirect "resources/bucket/#{params[:bucket_id]}/#{path}"
    else
      halt 500
    end
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