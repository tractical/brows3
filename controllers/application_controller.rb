# Application wide settings
# Other controllers should use this
require 'sinatra/base'
require 'sinatra/contrib'

class ApplicationController < Sinatra::Base
  register Sinatra::Contrib

  config_file '../config/config.yml'

  set :root, File.expand_path('../../', __FILE__)
  set :views, File.expand_path('../../views', __FILE__)

  configure :production, :development do
    enable :logging
    enable :sessions
  end

  not_found do
    erb :not_found
  end

  # helpers do
  #   def authorize_user(user)
  #     authorized_users = ENV['GITHUB_USERS'] || settings.github["users"]
  #     redirect '/auth/failure' unless (user && authorized_users.include?(user))
  #     session[:github_nickname] = user
  #   end

  #   def current_user
  #     if session[:github_nickname]
  #       @current_user = authorize_user(session[:github_nickname])
  #     else
  #       nil
  #     end
  #   end
  # end

end