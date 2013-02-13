# Application wide settings
# Other controllers should use this
require 'sinatra/base'
require 'sinatra/contrib'

class ApplicationController < Sinatra::Base
  register Sinatra::Contrib
  helpers ApplicationHelper

  config_file '../config/config.yml'

  set :root, File.expand_path('../../', __FILE__)
  set :views, Proc.new { File.join(root, 'views') }

  enable :method_override

  configure :production, :development do
    enable :logging
    enable :sessions
    set :sessions, key: "oauth_github"
    set :session_secret, ENV['SESSION_SECRET'] || settings.session["secret"]
  end

  not_found do
    erb :not_found
  end

  get '/' do
    erb :index
  end

end