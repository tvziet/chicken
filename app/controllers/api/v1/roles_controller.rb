module Api
  module V1
    class RolesController < ApplicationController
      def index
        roles = Role.order(name: :asc)
        render json: RoleSerializer.new(roles).serialized_json, status: :ok
      end
    end
  end
end
