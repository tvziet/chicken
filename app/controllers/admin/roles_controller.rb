module Admin
  class RolesController < BaseController
    before_action :authenticate_user!, only: %i[create update destroy]
    before_action :ensure_super_admin_user, only: %i[create update destroy]
    before_action :set_role, only: %i[show update destroy]

    def index
      roles = Role.order(name: :asc)
      pagy, data = pagy(roles, items: adjusted_per_page_param, page: adjusted_page_param)
      render json: json_with_pagination(data: data, options: pagy.vars), status: :ok
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

    def ensure_super_admin_user
      render json: json_with_error(message: I18n.t('errors.no_permission')), status: :forbidden unless current_user.super_admin?
    end
  end
end
