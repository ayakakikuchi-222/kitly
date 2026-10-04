module UiKitsHelper
  def ui_kit_image(ui_kit)
    ui_kit.image_url.presence || "placeholder.png"
  end

  # Live preview for the Dashboard cards.
  # It builds a tiny web page from the kit's own components:
  # the navbar across the top, then up to 3 other components side by side.
  def kit_preview_srcdoc(ui_kit)
    components = ui_kit.components.sort_by(&:created_at)
    navbar = components.find { |component| component.category.to_s.downcase.start_with?("nav") }
    others = (components - [navbar]).first(3)
    shown = [navbar, *others].compact

    # each component keeps its own <style>, so one component's CSS can't break the next one
    styles = shown.map { |component| "<style>#{component.css_code}</style>" }.join("\n")
    top = navbar ? %(<div class="kitly-preview-nav">#{navbar.html_code}</div>) : ""
    items = others.map { |component| %(<div class="kitly-preview-item">#{component.html_code}</div>) }.join("\n")

    <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
          #{stylesheet_link_tag 'application'}
          <style>
            html, body { margin: 0; overflow: hidden; background: #fff; }
            body { box-sizing: border-box; min-height: 100vh; display: flex; flex-direction: column; padding: 28px 32px; font-family: 'Baloo 2', sans-serif; }
            .kitly-preview-nav { margin-bottom: 28px; }
            .kitly-preview-row { margin: auto 0; display: flex; gap: 32px; justify-content: center; align-items: center; }
            .kitly-preview-item { flex: 0 0 300px; display: flex; justify-content: center; }
            /* smaller cards show fewer components instead of squashing them */
            @media (max-width: 1019px) { .kitly-preview-item:nth-child(3) { display: none; } }
            @media (max-width: 695px) { .kitly-preview-item:nth-child(2) { display: none; } }
          </style>
          #{styles}
        </head>
        <body>
          #{top}
          <div class="kitly-preview-row">#{items}</div>
        </body>
      </html>
    HTML
  end
end
