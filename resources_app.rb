require 'sinatra'
require 'sinatra/reloader' if development?
require 'debugger'

require 'yaml'

aws_yml = File.expand_path('../aws.yml',  __FILE__)
AWS_CONFIG = YAML.load_file(aws_yml)