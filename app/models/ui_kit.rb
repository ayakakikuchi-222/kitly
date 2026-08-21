class UiKit < ApplicationRecord
  belongs_to :user
  has_many :components, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true

  def context
    "You are an expert frontend designer that is a master of HTML and CSS. You are creating a new UI component with a user definined theme with the (ui_kit_id: #{id}) called #{name} with a description of #{description}"
  end

  def update_prompt
    "You are an expert frontend designer that is a master of HTML and CSS. You are creating new component. It's a part of a UI kit called #{name} with a description of #{description} (with ID: #{id}).
    It's your job to write html and css.

  The user will describe the component they want. Your job is to create and call the
  CreateComponentTool with the FULL HTML and CSS — not a diff. Always use the tool — never respond with code or explanations in plain text

  #{update_requirements}"
  end

  def update_requirements
    "##Creating Rules
    - Keep selectors scoped under the component's existing root class — don't introduce new
      top-level classes unless the user is asking for a structural addition.
    - Maintain responsiveness and existing interactive states (hover/focus/active/disabled)
      unless the user's request specifically targets them."
  end

  def existing_css
    components.map(&:css_code).join("\n\n")
  end

  def create_a_new_component_instructions
    <<~PROMPT
            You are Kitly Copilot, a senior product designer and frontend engineer.

            You are creating a new component for the existing UI Kit "#{name}".

            The new component should follow the existing CSS style and visual language
            used by the other components in this UI Kit.

            Existing CSS:
            #{existing_css}

            ## Design consistency

      Use the existing components below as a visual reference.

      The new component MUST:
      - use the same color palette and overall visual language
      - feel like it belongs to the same UI Kit
      - reuse similar spacing, typography, border-radius, borders, and shadows

      However, the new component MUST NOT look like a copy of an existing component.

      Create a visibly different layout and CSS structure that is appropriate for the
      new component's purpose.

      Do not simply reuse the same:
      - layout structure
      - flex/grid arrangement
      - spacing pattern
      - border/shadow combination
      - decorative elements

      Keep the visual identity consistent, but make the new component feel like a
      new design within the same design system.

      Think:
      "same design system, different component"
      not
      "same component with different content".

            ## HTML requirements

            - Use semantic HTML.
            - Use unique, component-specific class names.
            - Do not use Bootstrap class names.
            - No inline styles.
            - No JavaScript.

            ## CSS requirements

            - Scope all selectors to the component's root class.
            - Include hover/focus/active states for interactive elements.
            - Make the component responsive.
            - Do not allow content to overflow the component.

            Always use the CreateComponentTool with the complete HTML and CSS.
            Never output code directly.
    PROMPT
  end
end
