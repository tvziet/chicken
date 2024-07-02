module Users
  # Create a new user
  class UserCreatorService < BaseService
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def call
      role = Role.find_by!(id: params[:role_id])
      ActiveRecord::Base.transaction do
        user = User.create!(params)
        # The user represents an organization
        if role.name == Role::ORG_USER.to_s
          organization = Organization.find_or_create_by(email: params[:organization_attributes][:email],
                                                        name: params[:organization_attributes][:name],
                                                        short_name: params[:organization_attributes][:short_name])
          if organization.persisted?
            user.errors.add(:organization, message: 'already exists')
          else
            user.organization = organization
          end
        end
        role.user_roles << UserRole.find_or_create_by(user: user, role: role)

        success_response(user)
      end
    rescue ActiveRecord::RecordNotFound => e
      error_response({ e.model.downcase.to_sym => ['does not exist'] })
    rescue ActiveRecord::RecordInvalid => e
      error_response(e.record.errors.to_hash)
    end
  end
end
