require 'fog'
require 'tree'

class ResourcesController < ApplicationController

  before do
    if authorized?
      aws_access_key = ENV['S3_KEY']    || settings.aws["access_key"]
      aws_secret_key = ENV['S3_SECRET'] || settings.aws["secret_key"]
      @storage = Fog::Storage::AWS.new(
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
        # position = file.key.end_with?('/') && parent != @@tree.root ? 0 : -1
        parent.add(Tree::TreeNode.new(splitted_key.last, file))
      else
        @@tree.add(Tree::TreeNode.new(splitted_key.last, file))
      end
    end

    @directories = @@tree.children.select { |node| node.has_children? }
    @files = @@tree.children.select { |node| node.is_leaf? }

    erb :'resources/buckets/show'
  end

  get '/bucket/:bucket_id/*/edit' do
    bucket = @storage.directories.get(params[:bucket_id])
    if @file  = bucket.files.get(params[:splat].first + "/")
      erb :'resources/directories/edit'
    else
      erb :not_found
    end
  end

  get '/bucket/:bucket_id/*/?' do
    path = params[:splat].first.split('/')
    node = @@tree.find { |node| node.name == path.last }
    @directories = node.children.select { |node| node.has_children? }
    @files = node.children.select { |node| node.is_leaf? }

    erb :'resources/files/index'
  end

  # Update Folder name
  put '/bucket/:bucket_id/:key/edit/?' do
    bucket = @storage.directories.get(params[:bucket_id])
    file   = bucket.files.get(params[:id])
    child_files = bucket.files.all(prefix: params[:id])

    if file.key.split('/').last != params[:name]
      # Copy files and directory with new name.
      new_name = params[:name].gsub(/\/$/, '') + "/"
      new_file = file.copy(params[:bucket_id], file.key.gsub(/([^\/]*)\/$/, new_name)) unless params[:name].empty?
      child_files.each do |cf|
        next if cf.key == params[:id]

        new_cf = cf.copy(params[:bucket_id], cf.key.gsub(params[:id], new_file.key))
        cf.destroy
      end

      file.destroy
    end

    redirect '/buckets'
  end

  # Delete folder.
  # Delete files inside the folder first, the folder last.
  delete '/bucket/:bucket_id/:key' do
    bucket = @storage.directories.get(params[:bucket_id])
    file   = bucket.files.get(params[:id])

    bucket.files.all(prefix: params[:id]).each do |cf|
      cf.destroy
    end

    file.destroy

    redirect '/buckets'
  end

end