class SetUiKitDetailsTool < RubyLLM::Tool
  description "Sets the name and description for a new UI Kit, based on the user's description of the kind of website they're creating."

  param :name, desc: "A short, catchy name for the UI kit (a few words)."

  param :description, desc: <<~TXT
    A one-to-two sentence description of the kit's visual theme and purpose, written so it
    can guide another designer building components for it.
  TXT

  def initialize(ui_kit:)
    @ui_kit = ui_kit
  end

  def execute(name:, description:)
    @ui_kit.name = name
    @ui_kit.description = description
    { status: "set", name: @ui_kit.name, description: @ui_kit.description }
  end
end
