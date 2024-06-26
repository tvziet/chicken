# Description: Service object to switch role from individual user to org user
class SwitchRoleToOrgService < BaseService
  attr_reader :user, :organization_attributes, :new_role_id

  def initialize(user, organization_attributes, new_role_id)
    @user = user
    @organization_attributes = organization_attributes
    @new_role_id = new_role_id
  end

  def call
    organization = Organization.find_by(email: organization_attributes[:email],
                                        name: organization_attributes[:name],
                                        short_name: organization_attributes[:short_name],
                                        )
    # Check whether the organization's information has been registered by another user or not
    if organization
      user.errors.add(:organization, I18n.t("api.users.switch_role.organization_exists"))
      error_response(user.errors.messages)
    else
      current_organization = user.organization
      # If the current user already represents an organization, that organization's information will be updated
      # Otherwise, create a new organization
      if current_organization
        ActiveRecord::Base.transaction do
          current_organization.update!(email: organization_attributes[:email],
                               name: organization_attributes[:name],
                               short_name: organization_attributes[:short_name])
          user.update!(role_id: new_role_id)
        end
      else
        ActiveRecord::Base.transaction do
          organization = Organization.create!(email: organization_attributes[:email],
                                              name: organization_attributes[:name],
                                              short_name: organization_attributes[:short_name])
          UserRole.where(user_id: user.id, role_id: user.role_id).destroy_all
          user.update!(organization_id: organization.id, role_id: new_role_id)
          UserRole.create(user_id: user.id, role_id: new_role_id)
        end
      end

      success_response(user)
    end
  end
end