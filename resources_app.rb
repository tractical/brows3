require 'sinatra'
require 'sinatra/contrib/all'
require 'debugger' if development?
require 'fog'
require 'tree'

config_file 'config/config.yml'

before do
  aws_access_key = ENV['S3_KEY'] || settings.AWS["access_key"]
  aws_secret_key = ENV['S3_SECRET'] || settings.AWS["secret_key"]
  @storage = Fog::Storage::AWS.new(
    aws_access_key_id: aws_access_key,
    aws_secret_access_key: aws_secret_key)
end

get '/' do
  erb :index if @storage
end

get '/buckets' do
  @buckets = @storage.directories
  erb :buckets
end

get '/bucket/:id/?' do
  bucket = @storage.directories.get(params[:id])
  @files = bucket.files
  erb :bucket
end

get '/bucket/:bucket_id/files' do
  @tree = Tree::TreeNode.new(params[:prefix].split('/').last)
  bucket = @storage.directories.get(params[:bucket_id])
  files = bucket.files.all(prefix: params[:prefix])

  # TODO: Move to #make_tree method or something similar
  files.each do |file|
    next if file.key == params[:prefix]

    splitted_key = file.key.split('/')
    if splitted_key.size >= 1
      parent   = @tree.find { |node| node.name == splitted_key[-2] }
      position = file.key.end_with?('/') && parent != @tree.root ? 0 : -1
      parent.add(Tree::TreeNode.new(splitted_key.last, file), position)
    end
  end

  erb :files
end

delete '/delete' do
  bucket = @storage.directories.get(params[:directory])
  file = bucket.files.get(params[:key])
  file.destroy
  redirect('/buckets')
end

get '/bucket/:bucket_id/files/:key/edit' do
  bucket = @storage.directories.get(params[:bucket_id])
  @file  = bucket.files.get(params[:key] + "/")
  erb :edit
end

put '/bucket/:bucket_id/files/:key' do
  bucket = @storage.directories.get(params[:bucket_id])
  file   = bucket.files.get(params[:id])
  name = params[:name].gsub(/\/$/, '') + "/"
  # file.key = file.key.gsub(/([^\/]*)\/$/, params[:name]) unless params[:name].empty?
  # file.save
  file.copy(params[:bucket_id], file.key.gsub(/([^\/]*)\/$/, name)) unless params[:name].empty?
  redirect '/'
end