class Component < ApplicationRecord
  belongs_to :ui_kit
  has_many :messages, dependent: :destroy

  validates :category, presence: true
  validates :html_code, presence: true
  validates :css_code, presence: true

  def update_prompt
    "You are editing an existing component (id: #{id}, category: #{category}).

  Here is its current HTML:
html
  #{html_code}

  Here is its current CSS:
css
  #{css_code}

  The user will describe a change they want. Your job is to apply that change and call the
  UpdateComponentTool with the FULL updated HTML and CSS — not a diff, not just the changed
  lines. Always use the tool — never respond with code or explanations in plain text

  #{update_requirements}"
  end

  def update_requirements
    "## Editing Rules
    - Preserve existing class names, structure, and behavior EXCEPT where the user's request
      requires a change. Don't refactor or restyle parts the user didn't ask about.
    - If the user's request is ambiguous (e.g. 'make it pop'), make a reasonable, minimal
      interpretation rather than a dramatic rewrite.
    - Keep selectors scoped under the component's existing root class — don't introduce new
      top-level classes unless the user is asking for a structural addition.
    - Maintain responsiveness and existing interactive states (hover/focus/active/disabled)
      unless the user's request specifically targets them.

    ## Calling the tool
    - Always submit complete html_code and css_code representing the component's new full
      state, not just the delta.
    - Do not change `category` unless the user explicitly asks to recategorize the component."
  end
end
