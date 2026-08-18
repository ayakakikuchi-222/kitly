class ComponentsController < ApplicationController
  # /ui_kits/1/components/1
  def show
    @component = Component.find(params[:id])
  end

  def create
  end

  def destroy
  end
end
