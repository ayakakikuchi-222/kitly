class MessagesController < ApplicationController
  def create
    if params[:ui_kit_id]
      create_for_ui_kit
    elsif params[:component_id]
      create_for_component
    end
  end

  private

  def create_for_ui_kit
    @ui_kit = current_user.ui_kits.find(params[:ui_kit_id])
    @message = @ui_kit.messages.build(message_params)
    @message.role = "user"

    if @message.save
      redirect_to ui_kit_path(@ui_kit)
    else
      redirect_to ui_kit_path(@ui_kit), alert: @message.errors.full_messages.to_sentence
    end
  end

  def create_for_component
    @component = Component.find(params[:component_id])
    @message = @component.messages.build(message_params)
    @message.role = "user"

    return unless @message.save

    response = ai_response
    @component.reload
    # redirect_to component_path(@component)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [turbo_stream.update("card", partial: "components/card",
                                                          locals: { component: @component }), turbo_stream.update("new_message", partial: "messages/form", locals: { component: @component, message: Message.new }), turbo_stream.update("messages", partial: "messages/messages", locals: { messages: @component.messages })]
      end
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def ai_response
    ruby_llm_chat = RubyLLM.chat
    ruby_llm_chat.with_tool(UpdateComponentTool)
    ruby_llm_chat.with_instructions("#{@component.ui_kit.context}\n#{@component.update_prompt}")
    response = ruby_llm_chat.ask(@message.content)
  end
end
