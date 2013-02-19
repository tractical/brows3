# Application wide settings
# Other controllers should use this
require 'sinatra/base'
require 'sinatra/contrib'

class ApplicationController < Sinatra::Base
  register Sinatra::Contrib
  helpers ApplicationHelper

  config_file '../config/config.yml'

  configure :production, :development do
    enable :method_override
    enable :logging
    enable :sessions
    set :root, File.expand_path('../../', __FILE__)
    set :views, Proc.new { File.join(root, 'views') }
    set :session_secret, ENV['SESSION_SECRET'] || settings.session["secret"]
  end

  not_found do
    erb :not_found
  end

  get '/' do
    erb :index
  end

end