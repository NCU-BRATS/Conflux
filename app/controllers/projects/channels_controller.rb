class Projects::ChannelsController < Projects::ApplicationController

  enable_sync only: [:create, :update, :destroy]

  def show
    respond_with @project, @channel
  end

  def new
    @channel = Channel.new
    respond_with @project, @channel
  end

  def create
    @channel = @project.channels.build( channel_params )
    @channel.members << current_user
    if @channel.save
      event_service.create_channel(@channel, current_user)
    end
    respond_with @project, @channel
  end

  def edit
    respond_with @project, @channel
  end

  def update
    @channel.update_attributes( channel_params )
    respond_with @project, @channel
  end

  def destroy
    if @channel.destroy
      event_service.delete_channel(@channel, current_user)
    end
    respond_with @project, @channel
  end

  protected

  def resource
    @channel ||= Channel.friendly.find( params[:id] )
  end

  def channel_params
    params.require( :channel ).permit( :name, :description, :announcement )
  end

end
