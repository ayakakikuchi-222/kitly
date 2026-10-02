module ComponentsHelper
  # The component's HTML for its live preview.
  # The AI sometimes writes one closing tag too many (or forgets one). Put straight into the page,
  # that extra tag also closes Kitly's own boxes, and the kit page layout breaks.
  # Tidying the HTML first (the same way a browser reads it) keeps each component inside its own card.
  def component_preview_html(component)
    Nokogiri::HTML5.fragment(component.html_code.to_s).to_html.html_safe
  end
end
