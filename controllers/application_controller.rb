# Application wide settings
# Other controllers should use this

require 'sinatra/base'
require 'sinatra/contrib'
require 'rack-flash'
require 'debugger'

class ApplicationController < Sinatra::Base
  register Sinatra::Contrib
  helpers ApplicationHelper
  use Rack::Flash

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

  error do
    flash[:alert] = "OMG! Something went wrong! We'll get to it asap!"
    redirect to '/'
  end

  get '/', provides: :html do
    respond_with :index
  end

  get '/login' do
    erb :index
  end

  get '/logout' do
    session.clear
    flash[:alert] = "You have logged out."
    redirect to '/'
  end

  post '/login' do
    session[:aws_access] = params[:aws_access].empty? ? nil : params[:aws_access].strip
    session[:aws_secret] = params[:aws_secret].empty? ? nil : params[:aws_secret].strip
    redirect to '/resources'
  end


end