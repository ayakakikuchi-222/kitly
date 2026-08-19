module UiKitsHelper
  def ui_kit_image(ui_kit)
    ui_kit.image_url.presence || "placeholder.png"
  end
end
