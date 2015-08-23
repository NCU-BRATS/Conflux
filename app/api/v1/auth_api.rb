module V1
  class AuthAPI < Grape::API

    helpers do
      def generate_jwt( user, expire_time )
        token = JwtToken.new
        token.iat = Time.now.to_i
        token.exp = Time.now.to_i + expire_time
        token.sub = user.id
        token.save!
        token_info = {
            jti: token.id,
            iat: token.iat,
            exp: token.exp,
            sub: token.sub
        }
        JWT.encode token_info, Rails.application.secrets.jwt_hmac_secret, 'HS512'
      end
    end

    desc 'exchange jwt token by providing email and password'
    params do
      requires :usermail, type: String
      requires :password, type: String
    end
    post :authentication do
      user = User.find_by_email( params[:usermail] )
      unless user.present? and user.valid_password?( params[:password] )
        error_message( 'user not exist or authorization failed', 401 )
      end
      { token: generate_jwt( user, 14400 ), expires_in: 14400 }
    end

    group do
      before do
        authenticate_api_user!
      end

      desc 'revoke jwt token'
      delete :authentication do
        current_jwt_record.delete
        body false
      end

      desc 'refresh jwt token'
      put :authentication do
        current_jwt_record.delete
        { token: generate_jwt( current_api_user, 14400 ), expires_in: 14400 }
      end
    end

  end
end