class Projects::MessagesController < Projects::ApplicationController

  enable_sync only: [:create]

  def create
    @form = MessageOperation::Create.new(current_user, Channel.friendly.find(params[:channel_id]))
    @form.process(params)
    respond_with @project, @form
  end

  def update
    @form = MessageOperation::Update.new(current_user, @message)
    @form.process(params)
    respond_with @project, @form
  end

  def destroy
    @form = MessageOperation::Destroy.new(current_user, @message)
    @form.process
    respond_with @project, @form
  end

  protected

  def resource
    @message ||= Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit( :content )
  end

end
