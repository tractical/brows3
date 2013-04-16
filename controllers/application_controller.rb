# Application wide settings
# Other controllers should use this

require 'compass'
require 'sinatra/base'
require 'sinatra/contrib'
require 'rack-flash'

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
    erb :not_found, layout: false
  end

  error do
    erb :error, layout: false
  end

  get '/assets/stylesheets/:name.css' do
    content_type 'text/css', charset: 'utf-8'
    scss :"stylesheets/#{params[:name]}"
  end

  get %r{(\/.*[^\/])$} do
    redirect to "#{params[:captures].first}/"
  end

  get '/' do
    erb :index
  end

  get '/login/?' do
    erb :index
  end

  %w(terms faq privacy).each do |page|
    get "/#{page}/?" do
      erb page.intern
    end
  end

  get '/logout/?' do
    session.clear
    flash[:alert] = "You have logged out."
    redirect '/'
  end

  post '/login' do
    session[:aws_access] = params[:aws_access].empty? ? nil : params[:aws_access].strip
    session[:aws_secret] = params[:aws_secret].empty? ? nil : params[:aws_secret].strip
    validate_credentials
    redirect '/resources/buckets/'
  end
end
