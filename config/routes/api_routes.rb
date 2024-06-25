# frozen_string_literal: true

module ApiRoutes
  def self.extended(router)
    router.instance_exec do
      namespace :api do
        api_version(module: 'V1', header: { name: 'X-API-VERSION', value: 'v1' }) do
          post '/users', to: 'users#create'
          get '/me', to: 'users#me'
          get '/roles', to: 'roles#index'
          devise_for :users, singular: :user, skip: %i[registrations passwords confirmations],
            path: '',
            path_names: {
              sign_in: 'login',
              sign_out: 'logout'
            }
        end
      end
    end
  end
end
