module Api
  module V1
    class RolesController < ApplicationController
      def index
        roles = Role.order(name: :asc)
        render json: json_with_pagination(data: roles), status: :ok
      end
    end
  end
end
