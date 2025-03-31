module Api
  module V1
    class AuthController < BaseController
      skip_before_action :authenticate_api_request!, only: [:login]

      def login
        user = User.find_by(email: params[:email])
        
        if user&.valid_password?(params[:password])
          token = generate_jwt_token(user)
          render json: {
            token: token,
            user: {
              id: user.id,
              email: user.email,
              first_name: user.first_name,
              last_name: user.last_name,
              role: user.role
            }
          }
        else
          render json: { error: 'Email ou mot de passe invalide' }, status: :unauthorized
        end
      end

      private

      def generate_jwt_token(user)
        JWT.encode(
          { user_id: user.id, exp: 24.hours.from_now.to_i },
          Rails.application.credentials.secret_key_base
        )
      end
    end
  end
end 