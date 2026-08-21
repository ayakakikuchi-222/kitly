class MessagesController < ApplicationController
  def create
    if params[:component_id]
      @element = Component.find(params[:component_id])
    else
      @element = UiKit.find(params[:ui_kit_id])
    end
    @message = @element.messages.build(message_params)
    @message.role = "user"

    return unless @message.save

    response = ai_response
    @element.reload
    # redirect_to component_path(@element)
    # if element is component, do this
    if @element.class == Component
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [turbo_stream.update("card", partial: "components/card",
                                                            locals: { component: @element }), turbo_stream.update("new_message", partial: "messages/form", locals: { component: @element, message: Message.new }), turbo_stream.update("messages", partial: "messages/messages", locals: { messages: @element.messages })]
        end
      end
    # else element is uikit, make another respond to append new component
    else
      redirect_to ui_kit_path(@element)
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def ai_response
    ruby_llm_chat = RubyLLM.chat(model: "gpt-4.1-mini")
    ruby_llm_chat.with_tools(UpdateComponentTool, CreateComponentTool.new(ui_kit: @element))
    ruby_llm_chat.with_instructions(@element.update_prompt)
    response = ruby_llm_chat.ask(@message.content)
  end
end
