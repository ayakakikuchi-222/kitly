class UiKitsController < ApplicationController
  before_action :set_ui_kit, only: [:destroy]
  def show
    @ui_kit = UiKit.find(params[:id])
  end

  def index
    @ui_kits = current_user.ui_kits.order(:created_at)
    @ui_kit = current_user.ui_kits.new
  end

  def create
    @ui_kit = current_user.ui_kits.new(ui_kit_params)

    if @ui_kit.save
      redirect_to ui_kits_path, notice: "UI Kit was successfully created!"
    else
      redirect_to ui_kits_path, alert: @ui_kit.errors.full_messages.to_sentence
    end
  end

  def destroy
    @ui_kit.destroy
    redirect_to ui_kits_path, notice: "UI Kit was successfully deleted.", status: :see_other
  end

  private

  def set_ui_kit
    @ui_kit = current_user.ui_kits.find(params[:id])
  end

  def ui_kit_params
    params.require(:ui_kit).permit(:name, :description)
  end
end
