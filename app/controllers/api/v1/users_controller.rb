module Api
  module V1
    class UsersController < ApplicationController
      before_action :handle_unauthorized, unless: :current_user, only: %i[me update switch_role]
      before_action :set_role, only: %i[switch_role]

      def create
        result = Users::UserCreatorService.call(user_params)
        unless result.key?(:errors)
          UserMailer.with(user: result[:data]).verify_user.deliver_later
          render json: json_with_success(message: I18n.t('api.users.create.success'), data: result[:data]), status: :created
        end

        return render json: result, status: :not_found if result.key?(:errors) &&
          result[:errors].values.flatten.any? { |msg| msg.include?('does not exist') }

        render json: result, status: :unprocessable_entity if result.key?(:errors)
      end

      def me
        render json: json_with_success(data: current_user)
      end

      def update
        return render json: json_with_error(message: I18n.t('api.users.update.incorrect_current_password')), status: :unprocessable_entity \
          if params[:new_password].present? && !current_user.valid_password?(params[:current_password])

        return render json: json_with_error(message: I18n.t('api.users.update.fail'), errors: current_user.errors.messages), status: :unprocessable_entity \
          unless current_user.update(email: params[:email], password: params[:new_password], name: params[:name])

        render json: json_with_success(message: I18n.t('api.users.update.success'))
      end

      def switch_role
        # Check if the new role is within the role array that is allowed to be updated
        return render json: json_with_error(message: I18n.t('api.users.common.not_matching_role')) \
          if Role::REGISTERABLE_ROLES.exclude?(set_role.name)

        result = if set_role.name == Role::ORG_USER.to_s
          return render json: json_with_error(message: I18n.t('api.users.switch_role.missing_organization_attributes')), status: :unprocessable_entity \
            unless params[:organization_attributes]

          Users::SwitchRoleToOrgService.call(current_user, params[:organization_attributes], params[:new_role_id])
        else
          Users::SwitchRoleToIndividualService.call(current_user, params[:new_role_id])
        end

        return render json: json_with_error(errors: result[:errors]) if result.has_key?(:errors)

        render json: json_with_success(data: result[:data])
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :name, :role_id, organization_attributes: [:email, :name, :short_name])
      end

      def set_role
        @set_role ||= begin
          Role.find(params[:new_role_id])
        rescue ActiveRecord::RecordNotFound => e
          handle_record_not_found(e)
        end
      end
    end
  end
end
