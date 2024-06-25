module Api
  module V1
    class UsersController < ApplicationController
      before_action :handle_unauthorized, unless: :current_user, only: %i[me update]
      def create
        result = UserCreatorService.call(user_params)
        return render json: result, status: :unprocessable_entity if result.key?(:errors)

        UserMailer.with(user: result[:data]).verify_user.deliver_later

        render json: json_with_success(message: I18n.t('api.users.create.success'), data: result[:data]), status: :created
      end

      def me
        render json: json_with_success(data: current_user)
      end

      def update
        return render json: json_with_error(message: I18n.t("api.users.update.incorrect_current_password")), status: :unprocessable_entity \
          if params[:new_password].present? && !current_user.valid_password?(params[:current_password])

        return render json: json_with_error(message: I18n.t("api.users.update.fail"), errors: current_user.errors.messages), status: :unprocessable_entity \
          unless current_user.update(email: params[:email], password: params[:new_password], name: params[:name])

        render json: json_with_success(message: I18n.t("api.users.update.success"))
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :name, :role_id, organization_attributes: [:email, :name, :short_name])
      end
    end
  end
end
