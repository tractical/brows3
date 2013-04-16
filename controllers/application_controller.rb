# Application wide settings
# Other controllers should use this

require 'compass'
require 'sinatra/base'
require 'sinatra/contrib'
require 'sinatra/assetpack'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  register Sinatra::Contrib
  register Sinatra::AssetPack
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

  assets do
    serve "/javascripts", from: "assets/javascripts"
    serve "/stylesheets", from: "assets/stylesheets"
    serve "/images",      from: "assets/images"

    css :application, ["/stylesheets/normalize.css", "/stylesheets/app.css"]

    js  :foundation, [
      "/javascripts/foundation/foundation.js",
      "/javascripts/foundation/foundation.*.js"
    ]
    js :parallax, [
      "/javascripts/jparallax/jquery.event.frame.js",
      "/javascripts/jparallax/jquery.parallax.js"
    ]
    js :application, [
      "/javascripts/vendor/*.js",
      "/javascripts/brows3.js"
    ]
  end

  not_found do
    erb :not_found, layout: false
  end

  error do
    erb :error, layout: false
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
