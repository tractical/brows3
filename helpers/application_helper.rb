module ApplicationHelper

  def validate_credentials
    aws_access_key = session[:aws_access]
    aws_secret_key = session[:aws_secret]

    begin
      conn = Fog::Storage::AWS.new(
        aws_access_key_id: aws_access_key,
        aws_secret_access_key: aws_secret_key)
      conn.directories.first
    rescue ArgumentError
      flash[:notice] = "Please make sure you are providing valid credentials."
      redirect '/logout'
    rescue Excon::Errors::Forbidden
      flash[:notice] = "Forbidden Access"
      redirect '/logout'
    else
      session[:logged_in] = true
    end
  end
end