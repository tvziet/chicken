module Api
  module V1
    class UsersController < ApplicationController
      def create
        result = UserCreatorService.call(user_params)
        return render json: result, status: :unprocessable_entity if result.key?(:errors)

        UserMailer.with(user: result[:data]).verify_user.deliver_later

        render json: json_with_success(message: I18n.t('api.users.create.success'), data: result[:data]), status: :created
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :name, :role_id, organization_attributes: [:email, :name, :short_name])
      end
    end
  end
end
