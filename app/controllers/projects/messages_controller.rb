class Projects::MessagesController < Projects::ApplicationController

  def index
    @channel = @project.channels.find_by_slug( params[:channel_id] )
    @messages = @channel.messages.includes(:user).order('id desc').limit(50).search(params[:q]).result.reverse
  end

  def create
    @channel = @project.channels.find_by_slug(params[:channel_id])
    @form = MessageOperation::Create.new(current_user, @channel)
    @form.process(params)
    PrivatePub.publish_to(private_pub_channel, {
      action: 'create',
      target: 'message',
      data:   @form.model.as_json(include: :user)
    })
  end

  def update
    @form = MessageOperation::Update.new(current_user, @message)
    @form.process(params)
    PrivatePub.publish_to(private_pub_channel, {
      action: 'update',
      target: 'message',
      data:   @form.model.as_json(include: :user)
    })
  end

  def destroy
    @form = MessageOperation::Destroy.new(current_user, @message)
    @form.process
    PrivatePub.publish_to(private_pub_channel, {
      action: 'destroy',
      target: 'message',
      data:   @form.model
    })
  end

  protected

  def resource
    @message ||= Message.find(params[:id])
  end

  def private_pub_channel
    @private_pub_channel ||= "/projects/#{@project.id}/channels/#{@form.model.channel.id}"
  end

end
