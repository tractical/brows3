require 'fog'
require 'tree'

class ResourcesController < ApplicationController

  before do
    if authorized?
      aws_access_key = ENV['S3_KEY']    || settings.aws["access_key"]
      aws_secret_key = ENV['S3_SECRET'] || settings.aws["secret_key"]
      @storage ||= Fog::Storage::AWS.new(
        aws_access_key_id: aws_access_key,
        aws_secret_access_key: aws_secret_key)
    end
  end

  # buckets#index
  get '/buckets' do
    @buckets = @storage.directories
    erb :'resources/buckets/index'
  end

  # buckets#show
  get '/bucket/:id/?' do
    bucket = @storage.directories.get(params[:id])
    files = bucket.files

    # Populate Tree to avoid calls to Fog
    @@tree = Tree::TreeNode.new(bucket.key) # Root node

    # TODO: Move to #make_tree method or something similar
    files.each do |file|
      splitted_key = file.key.split('/')
      if splitted_key.size >= 2
        parent   = @@tree.find { |node| node.name == splitted_key[-2] }
        parent.add(Tree::TreeNode.new(splitted_key.last, file))
      else
        @@tree.add(Tree::TreeNode.new(splitted_key.last, file))
      end
    end

    @directories = @@tree.children.select { |node| node.has_children? }
    @files = @@tree.children.select { |node| node.is_leaf? }

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
    else
      halt 500
    end

    redirect "/resources/bucket/#{bucket.key}/"
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
      bucket.files.create(key: file.key + "delete me")
      redirect "resources/bucket/#{params[:bucket_id]}/"
    else
      halt 500
    end
  end

  # files#index
  get '/bucket/:bucket_id/*/?' do
    path = params[:splat].first.split('/')
    node = @@tree.find { |node| node.name == path.last }
    @directories = node.children.select { |node| node.has_children? }
    @files = node.children.select { |node| node.is_leaf? }

    erb :'resources/files/index'
  end

end