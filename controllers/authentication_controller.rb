require 'omniauth'
require 'omniauth-github'

class AuthenticationController < ApplicationController

  configure do
    set :sessions, key: "oauth_github"
    set :session_secret, ENV['SESSION_SECRET'] || settings.session["secret"]
  end

  use OmniAuth::Builder do
    client_id     = ENV['GITHUB_KEY']    || AuthenticationController.github["client_id"]
    client_secret = ENV['GITHUB_SECRET'] || AuthenticationController.github["client_secret"]
    state         = ENV['GITHUB_STATE']  || AuthenticationController.github["state"]
    provider :github, client_id, client_secret, state: state
  end

  get '/' do
    "Authenticate plz!"
  end

  get '/auth/:name/callback' do
    auth = request.env['omniauth.auth']
    # authorize_user(auth['info']['nickname'])
    redirect '/'
  end

  get '/auth/failure' do
    session.clear
    erb :not_authorized
  end

end