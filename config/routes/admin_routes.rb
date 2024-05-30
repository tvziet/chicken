# frozen_string_literal: true

module AdminRoutes
  def self.extended(router)
    router.instance_exec do
      namespace :admin do
        resources :roles
      end
    end
  end
end
