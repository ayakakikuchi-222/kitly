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
end
