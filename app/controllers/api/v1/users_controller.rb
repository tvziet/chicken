module Api
  module V1
    class UsersController < ApplicationController
      def create
        result = UserCreatorService.call(user_params)
        return render json: result, status: :unprocessable_entity if result.key?(:errors)

        render json: UserSerializer.new(result[:data]).serialized_json, status: :created
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :name, :role_id, organization_attributes: [:email, :name, :short_name])
      end
    end
  end
end
