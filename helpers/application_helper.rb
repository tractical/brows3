module ApplicationHelper

  def authorized?
    if session[:github_nickname]
      authorized_users = ENV['GITHUB_USERS'] || settings.github["users"]
      authorized_users.include?(session[:github_nickname]) ? true : redirect('/authenticate/auth/failure')
    else
      session.clear
      redirect('/authenticate/auth/failure')
    end
  end

  def current_user
    authorized? ? session[:github_nickname] : nil
  end

end