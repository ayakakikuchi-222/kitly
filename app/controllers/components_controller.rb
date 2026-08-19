class ComponentsController < ApplicationController
  # /ui_kits/1/components/1

  before_action :set_component, only: %i[show update destroy]
  def show
    @component = Component.find(params[:id])
    @message = Message.new
  end

  def update
    if @component.update(component_params)
      redirect_to component_path(@component), notice: "Component was successfully updated."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def create
  end

  def destroy
  end

  private

  def set_component
    @component = current_user.components.find(params[:id])
  end

  def component_params
    params.require(:component).permit(:category, :html_code, :css_code)
  end
end
