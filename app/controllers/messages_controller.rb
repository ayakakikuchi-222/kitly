class MessagesController < ApplicationController
  def create
    @component = Component.find(params[:component_id])
    @message = @component.messages.build(message_params)
    @message.role = "user"

    if @message.save
      redirect_to component_path(@component), notice: "Component was successfully created."
    else
      render "components/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
