require 'omniauth'
require 'omniauth-github'

class AuthenticationController < ApplicationController

  use OmniAuth::Builder do
    client_id     = ENV['GITHUB_KEY']    || AuthenticationController.github["client_id"]
    client_secret = ENV['GITHUB_SECRET'] || AuthenticationController.github["client_secret"]
    state         = ENV['GITHUB_STATE']  || AuthenticationController.github["state"]
    provider :github, client_id, client_secret, state: state
  end

  get '/auth/:name/callback' do
    auth = request.env['omniauth.auth']
    session[:github_nickname] = auth['info']['nickname']
    redirect '/'
  end

  get '/auth/failure' do
    session.clear
    erb :'authentication/not_authorized'
  end

end