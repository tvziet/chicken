module Users
  # Switch role from individual user to org user
  class SwitchRoleToOrgService < BaseService
    attr_reader :user, :organization_attributes, :new_role_id

    def initialize(user, organization_attributes, new_role_id)
      @user = user
      @organization_attributes = organization_attributes.is_a?(Hash) ? organization_attributes : organization_attributes.to_unsafe_h
      @new_role_id = new_role_id
    end

    def call
      if organization_registered?
        user.errors.add(:organization, I18n.t('api.users.switch_role.organization_registered'))
        error_response(user.errors.messages)
      else
        current_organization ? process_update_current_organization : process_create_current_organization
        success_response(user)
      end
    end

    private

    def current_organization
      @current_organization ||= user.organization
    end

    # Check whether the organization's information has been registered by another user or not
    def organization_registered?
      Organization.exists?(organization_attributes)
    end

    # If the current user already represents an organization, that organization's information will be updated
    def process_update_current_organization
      ActiveRecord::Base.transaction do
        current_organization.update!(organization_attributes)
        user.update!(role_id: new_role_id)
      end
    end

    # Otherwise, create a new organization
    def process_create_current_organization
      ActiveRecord::Base.transaction do
        # Create the organization and associate it with the user.
        user.create_organization(organization_attributes)

        # Clear existing roles and update the user's role.
        UserRole.where(user_id: user.id).destroy_all
        user.update!(role_id: new_role_id)

        # Assign the new role to the user.
        UserRole.create(user_id: user.id, role_id: new_role_id)
      end
    end
  end
end
