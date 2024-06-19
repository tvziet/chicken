class ApplicationController < ActionController::API
  include Pagy::Backend

  include ResponseHandler
  include ErrorsHandler

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    keys = [:name]
    devise_parameter_sanitizer.permit(:account_update, keys: keys)
    devise_parameter_sanitizer.permit(:sign_up, keys: keys)
  end
end
