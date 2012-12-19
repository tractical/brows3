require 'sinatra'
require 'sinatra/reloader' if development?
require 'debugger' if development?
require 'fog'

require 'yaml'

aws_yml = File.expand_path('../aws.yml',  __FILE__)
APP_CONFIG = YAML.load_file(aws_yml)["defaults"]

before do
  @storage = Fog::Storage::AWS.new(
    aws_access_key_id: APP_CONFIG["aws_access_key"],
    aws_secret_access_key: APP_CONFIG["aws_secret_key"])
end


get '/' do
  "Connected to AWS" if @storage
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
  bucket = @storage.directories.get(params[:bucket_id])
  @files = bucket.files.all(prefix: params[:prefix])
  @files.group_by do |file|
    @files.prefix
  end
  erb :files
end