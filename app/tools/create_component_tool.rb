class CreateComponentTool < RubyLLM::Tool
  description "Creates a new UI component (like a button, card, navbar, form, etc.) for the current UI Kit, based on the user's description."

  param :category, desc: "A short name for the type of component being created, e.g. 'Button', 'Card', 'Navbar'."

  param :html_code, desc: <<~TXT
    Pure HTML markup for the component. Must contain only valid HTML tags and attributes —
    no inline <style> tags, no <script> tags, and no external resource links. CSS classes
    and IDs may be used freely, as their styles will be defined separately in css_code. Do
    not wrap the output in a full HTML document (no <html>, <head>, or <body> tags) — return
    only the relevant HTML fragment.
  TXT

  param :css_code, desc: <<~TXT
    Pure CSS rules for styling the component. Must contain only valid CSS — no <style>
    wrapper tags, no JavaScript, and no HTML. All selectors should be scoped using a class
    specific to this component to avoid conflicts with other components on the page.
  TXT

  def initialize(ui_kit:)
    @ui_kit = ui_kit
  end

  def execute(category:, html_code:, css_code:)
    component = @ui_kit.components.create(category: category, html_code: html_code, css_code: css_code)
    { status: "created", component_id: component.id, category: component.category }
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end
end
