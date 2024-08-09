# frozen_string_literal: true

module Api
  module V1
    class SessionsController < Devise::SessionsController
      include ResponseHandler
      include ErrorsHandler

      def create
        user = User.find_for_authentication(email: sign_in_params[:email])
        if user&.valid_password?(sign_in_params[:password])
          token = user.generate_access_token
          render json: json_with_success(message: I18n.t('api.sessions.create.success'),
            data: user, options: { token: token }),
            status: :ok
        else
          head :unauthorized
        end
      end

      private

      def sign_in_params
        params.require(:user).permit(:email, :password)
      end

      def respond_to_on_destroy
        return render_unauthorized if request.headers['Authorization'].blank?

        jwt_payload = decode_jwt(request.headers['Authorization'].split.last)&.with_indifferent_access
        return render_unauthorized if jwt_payload.blank?

        current_user = User.find_by(id: jwt_payload[:sub])
        return render_unauthorized unless current_user

        # Add a check for the 'jti' claim
        return render_unauthorized if jwt_payload[:jti].blank? || current_user.jti != jwt_payload[:jti]

        render json: json_with_success(message: I18n.t('api.sessions.destroy.success')), status: :ok
      end

      def decode_jwt(token)
        JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY']).first
      end

      def render_unauthorized
        render json: json_with_error(message: I18n.t('api.sessions.destroy.fail')), status: :unauthorized
      end
    end
  end
end
