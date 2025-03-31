module Api
  module V1
    class BaseController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_api_request!

      private

      def authenticate_api_request!
        token = request.headers['Authorization']&.split(' ')&.last
        return render_unauthorized unless token

        begin
          decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base)
          @current_user = User.find(decoded_token[0]['user_id'])
        rescue JWT::DecodeError
          render_unauthorized
        end
      end

      def render_unauthorized
        render json: { error: 'Non autorisé' }, status: :unauthorized
      end

      def current_user
        @current_user
      end
    end
  end
end 