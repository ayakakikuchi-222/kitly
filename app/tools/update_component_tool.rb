class UpdateComponentTool < RubyLLM::Tool
  description "Use this tool when the user asks to update the component."

  param :html_code, desc: <<~TXT
    Pure HTML markup for the component. Must contain only valid HTML tags and attributes — no
    inline <style> tags, no <script> tags, and no external resource links. CSS classes and
    IDs may be used freely, as their styles will be defined separately in css_code. Do not
    wrap the output in a full HTML document (no <html>, <head>, or <body> tags) — return
    only the relevant HTML fragment.
  TXT

  param :css_code, desc: <<~TXT
    Pure CSS rules for styling the component. Must contain only valid CSS — no <style> wrapper
    tags, no JavaScript, and no HTML. All selectors should be scoped using the component's
    name as a prefix or class to avoid conflicts (e.g. `.component-name .child`). Do not use
    inline styles or !important unless absolutely necessary. External fonts or resources
    should be imported at the top using @import.
  TXT

  param :component_id, desc: "This is the ID of the component, which will be provided in the prompt"

  def execute(html_code:, css_code:, component_id:)
    component = Component.find(component_id)
    puts
    puts
    puts "HTML is the exact same: #{component.html_code == html_code}"
    puts "CSS is the exact same: #{component.css_code == css_code}"
    puts
    puts
    if component.update(html_code: html_code, css_code: css_code)
      { success: true, component_id: component.id }
    else
      # tell the AI what went wrong
      { success: false, errors: component.errors.full_messages }
    end
  end
end
