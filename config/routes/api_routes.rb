# frozen_string_literal: true

module ApiRoutes
  def self.extended(router)
    router.instance_exec do
      namespace :api do
        api_version(module: 'V1', header: { name: 'X-API-VERSION', value: 'v1' }) do
          devise_for :users, controllers: {
            sessions: 'users/sessions'
          }
        end
      end
    end
  end
end
