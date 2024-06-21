module Api
  module V1
    class RolesController < ApplicationController
      def index
        roles = Role.order(name: :asc)
        pagy, data = pagy(roles, items: params[:per_page])
        render json: json_with_pagination(data: data, options: pagy.vars), status: :ok
      end
    end
  end
end
