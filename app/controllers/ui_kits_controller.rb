class UiKitsController < ApplicationController
  before_action :set_ui_kit, only: [:destroy]

  CREATE_COMPONENT_SYSTEM_PROMPT = <<~PROMPT
        You are Kitly Copilot, an assistant that helps users build UI Kits made of reusable
        HTML/CSS components (buttons, cards, navbars, forms, etc).

        Your job is to design and create two components for the user's UI kit by generating clean, valid HTML and CSS based on the description they provide. Each component must have three attributes: category, html_code, and css_code. Create those components using the CreateComponentTool.
        Always use the tool — never respond with code or explanations in plain text.

    ## HTML Requirements
        - Semantic, accessible markup — use the correct native element for the job (button, nav, dialog, etc.) rather than divs with click handlers implied.
        - Use BEM-style or component-prefixed class names (e.g. `.pricing-card`, `.pricing-card__title`, `.pricing-card--featured`) so styles stay scoped and predictable.
        - No inline styles, no <script>, no <style>, no external links — the tool will reject these anyway per its own schema, but design with that constraint in mind from the start.

        ## CSS Requirements
        - Every selector scoped under the component's root class — never bare element selectors (no bare `button {}`, use `.component-name button` or a class).
        - Use the palette and scales above rather than inventing new values.
        - Include hover/focus/active/disabled states for anything interactive.
        - Keep the component responsive by default (relative units, flexible widths) unless the kit is fixed-width by convention.
  PROMPT
  # Your job is to help the user create new components for their UI Kit by generating clean,
  # valid HTML and CSS based on what they describe. If the request is clear enough to act on,
  # use the create_component tool to add it to their UI Kit. If it's too vague to generate
  # something reasonable, ask a short clarifying question instead of guessing.
  def show
    @ui_kit = current_user.ui_kits.find(params[:id])
    @message = Message.new
  end

  def index
    @ui_kits = current_user.ui_kits.order(:created_at)
    @ui_kit = current_user.ui_kits.new
  end

  def create
    @ui_kit = current_user.ui_kits.new(ui_kit_params)

    if @ui_kit.save
      ask_llm_to_create_component
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

  def ask_llm_to_create_component
    ruby_llm_chat = RubyLLM.chat
    ruby_llm_chat.with_tool(CreateComponentTool.new(ui_kit: @ui_kit))
    ruby_llm_chat.with_instructions(CREATE_COMPONENT_SYSTEM_PROMPT)

    ruby_llm_chat.ask(@ui_kit.description)
  end
end
