class UiKitsController < ApplicationController
  def index
    @ui_kits = current_user.ui_kits
  end
end
