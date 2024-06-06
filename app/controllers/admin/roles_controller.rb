module Admin
  class RolesController < BaseController
    before_action :set_role, only: %i[show update destroy]

    def index
      roles = Role.order(name: :asc)
      render json: json_with_pagination(data: roles), status: :ok
    end

    def show
      render json: json_with_success(data: set_role), status: :ok
    end

    def create
      role = Role.create!(role_params)
      render json: json_with_success(message: I18n.t('admin.roles.create.success'), data: role), status: :created
    rescue ActiveRecord::RecordInvalid => e
      handle_record_invalid(e)
    end

    def update
      set_role.update!(role_params)
      render json: json_with_success(message: I18n.t('admin.roles.update.success'), data: set_role), status: :ok
    rescue ActiveRecord::RecordInvalid => e
      handle_record_invalid(e)
    end

    def destroy
      set_role.destroy
      render json: json_with_success(message: I18n.t('admin.roles.destroy.success')), status: :ok
    end

    private

    def role_params
      params.require(:role).permit(:name)
    end

    def set_role
      Role.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      handle_record_not_found(e)
    end
  end
end
