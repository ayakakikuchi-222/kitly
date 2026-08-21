class Component < ApplicationRecord
  belongs_to :ui_kit
  has_many :messages, dependent: :destroy

  validates :category, presence: true
  validates :html_code, presence: true
  validates :css_code, presence: true

  def update_prompt
    "You are an expert frontend designer that is a master of HTML and CSS. You are editing an existing component (id: #{id}, category/name: #{category}). It's a part of a UI kit called #{ui_kit.name} with a description of #{ui_kit.description}.
    It's your job to find the part of the component html or css to see what the user what's to change and update it. Sometimes there are complex components with layers of html and css, you need to find the correct parts to change.

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
    - Keep selectors scoped under the component's existing root class — don't introduce new
      top-level classes unless the user is asking for a structural addition.
    - Maintain responsiveness and existing interactive states (hover/focus/active/disabled)
      unless the user's request specifically targets them.

    ## Calling the tool
    - Always submit complete html_code and css_code representing the component's new full
      state, not just the delta.
    - Always create a new version of the html and css code based on the user's request, never the exact same
    - Do not change `category` unless the user explicitly asks to recategorize the component."
  end
end
