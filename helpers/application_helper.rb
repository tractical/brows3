module ApplicationHelper
  include Sprockets::Helpers

  def validate_credentials
    aws_access_key = session[:aws_access]
    aws_secret_key = session[:aws_secret]

    begin
      s3 = AWS::S3.new(access_key_id: aws_access_key, secret_access_key: aws_secret_key)
      s3.buckets.first
    rescue AWS::Errors::MissingCredentialsError, AWS::S3::Errors::SignatureDoesNotMatch,
            AWS::S3::Errors::InvalidAccessKeyId, ArgumentError
      session.clear
      flash[:notice] = "Please make sure you are providing valid credentials."
      redirect '/'
    else
      session[:logged_in] = true
    end
  end

  def controller_name
    request.script_name.delete "/"
  end

end
