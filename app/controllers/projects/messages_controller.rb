class Projects::MessagesController < Projects::ApplicationController

  enable_sync only: [:create, :update, :destroy]

  def create
    @message = Channel.friendly.find( params[:channel_id] ).messages.build message_params
    @message.user = current_user
    @message.save
    respond_with @project, @message
  end

  def update
    @message.update_attributes(message_params)
    respond_with @project, @message
  end

  def destroy
    @message.destroy
    respond_with @project, @message
  end

  protected

  def resource
    @message ||= Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit( :content )
  end

end
