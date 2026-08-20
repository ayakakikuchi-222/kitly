class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_unread_count
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def set_unread_count
    @unread_count = 3 if user_signed_in?
  end

  def after_sign_in_path_for(resource)
    ui_kits_path
  end

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])

    # For additional fields in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname])
  end
end
