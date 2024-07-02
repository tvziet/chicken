module Users
  # Switch role from org user to individual user
  class SwitchRoleToIndividualService < BaseService
    attr_reader :user, :new_role_id

    def initialize(user, new_role_id)
      @user = user
      @new_role_id = new_role_id
    end

    def call
      if user.role_id == new_role_id
        user.errors.add(:new_role_id, I18n.t("api.users.switch_role.no_change"))
        error_response(user.errors.messages)
      else
        ActiveRecord::Base.transaction do
          organization = user.organization
          organization.destroy!
          UserRole.where(user_id: user.id, role_id: user.role_id).destroy_all
          user.update!(role_id: new_role_id)
          UserRole.create(user_id: user.id, role_id: new_role_id)
        end
        success_response(user)
      end
    end
  end
end
