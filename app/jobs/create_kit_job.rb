class CreateKitJob < ApplicationJob
  queue_as :default

  def perform(ui_kit)
    # Do something later
    ruby_llm_chat = RubyLLM.chat(model: "gpt-4.1-mini")
    ruby_llm_chat.with_tool(CreateComponentTool.new(ui_kit: ui_kit))
    ruby_llm_chat.with_instructions(ui_kit.create_multiple_component_instructions)

    ruby_llm_chat.ask(ui_kit.description)
  end
end
