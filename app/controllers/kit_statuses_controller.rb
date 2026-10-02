# The kit page's loading screen asks this every few seconds: is the kit still being made?
# GET /ui_kits/:ui_kit_id/status
class KitStatusesController < ApplicationController
  def show
    ui_kit = current_user.ui_kits.find(params[:ui_kit_id])

    render json: {
      generating: ui_kit.still_generating?,
      ready: ui_kit.components.count,
      total: UiKit::STARTER_COMPONENTS.size
    }
  end
end
