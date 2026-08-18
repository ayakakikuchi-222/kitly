class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_unread_count

  private

  def set_unread_count
    @unread_count = 3 if user_signed_in?
  end

  def after_sign_in_path_for(resource)
    ui_kits_path
  end
end
