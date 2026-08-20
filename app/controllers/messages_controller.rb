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

    if @message.save
      redirect_to component_path(@component), notice: "Component was successfully created."
    else
      render "components/show", status: :unprocessable_entity
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
