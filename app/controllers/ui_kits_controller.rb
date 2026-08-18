class UiKitsController < ApplicationController
  def show
    @ui_kit = UiKit.find(params[:id])
  end
end
