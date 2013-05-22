# Application wide settings
# Other controllers should use this

class ApplicationController < Sinatra::Base
  register Sinatra::Contrib
  register Sinatra::Sprockets::Helpers
  helpers ApplicationHelper
  use Rack::Flash

  config_file '../config/config.yml'

  enable :method_override
  enable :sessions
  set :root, File.expand_path('../../', __FILE__)
  set :session_secret, ENV['SESSION_SECRET']

  # Enable SSL
  set :use_ssl, true

  # Enable use of Sentry
  set :use_sentry, !ENV['SENTRY_DSN'].nil?

  set :mixpanel_code, ENV["MIXPANEL_CODE"]
  set :google_code, ENV["GOOGLE_CODE"]

  configure :production do
    use Rack::SSL if settings.use_ssl
  end

  not_found do
    erb :not_found, layout: false
  end

  error do
    # captures the exception and attempts to send it
    # to the Sentry API.
    Raven.capture_exception(env['sinatra.error']) if settings.use_sentry
    erb :error, layout: false
  end

  get %r{(\/.*[^\/])$} do
    redirect to "#{params[:captures].first}/"
  end

  get '/' do
    erb :home, layout: :homepage
  end

  get '/login/?' do
    erb :home, layout: :homepage
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
