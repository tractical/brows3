require "sinatra"
require "sinatra/reloader" if development?
require "debugger"

require 'yaml'

aws_yml = File.expand_path('../aws.yml',  __FILE__)
AWS_CONFIG = YAML.load_file(aws_yml)

AWS.config(access_key_id: AWS_CONFIG["development"]["access_key_id"], secret_access_key: AWS_CONFIG["development"]["secret_access_key"])

before do
  @s3 = AWS::S3.new
  @bucket = @s3.buckets["resources.tractical.com"]
end

get '/resources' do
  @resources = @bucket.resources(params[:prefix])
  erb :resources
end

get '/directories' do
  @directories = @bucket.directories(params[:prefix])
  erb :directories
end

get '/files' do
  @files = @bucket.files(params[:prefix])
  erb :files
end