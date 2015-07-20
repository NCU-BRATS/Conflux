module GrapeHelper extend Grape::API::Helpers

  def error_message( message, status )
    error!( { message: message } , status )
  end

  def current_authorization_token
    @authorization_toen ||= if headers['Authorization'].present? and headers['Authorization'] =~ /Bearer (.+)/
      $1
    else
      error_message( "token not provided in Authorization header like 'Bearer [your_token]'", 400 )
    end
  end

  def current_jwt_object
    @jwt_object ||= JWT.decode current_authorization_token, Rails.application.secrets.jwt_hmac_secret
  end

  def current_jwt_record
    @jwt_record ||= JwtToken.find_by_id( current_jwt_object[0]['jti'] )
  end

  def current_user
    @current_user ||= authenticate_user!
  end

  def authenticate_user!
    jwt_object = current_jwt_object
    jwt_record = current_jwt_record
    if jwt_record.present?
      jwt_record.last_used_at = Time.now
      jwt_record.save
      @current_user = User.find_by_id( jwt_object[0]['sub'] )
    else
      raise JWT::DecodeError
    end
  rescue JWT::DecodeError
    error_message( 'invalid authorization token', 401 )
  end

end
