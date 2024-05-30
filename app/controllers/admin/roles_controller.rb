module Admin
  class RolesController < BaseController
    before_action :set_role, only: %i[show update]

    def index
      roles = Role.order(name: :asc)
      render json: RoleSerializer.new(roles).serialized_json, status: :ok
    end

    def show
    end

    def create
      role = Role.create!(role_params)
      render json: RoleSerializer.new(role).serialized_json, status: :created
    rescue ActiveRecord::RecordInvalid => e
      handle_record_invalid(e)
    end

    def update
      @role.update!(role_params)
      render json: RoleSerializer.new(@role).serialized_json, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      handle_record_invalid(e)
    end

    private

    def role_params
      params.require(:role).permit(:name)
    end

    def set_role
      @role = Role.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      handle_record_not_found(e)
    end
  end
end
