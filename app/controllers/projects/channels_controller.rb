class Projects::ChannelsController < Projects::ApplicationController

  def index
    @q = @project.channels.search(params[:q])
    @channels = @q.result.uniq.page(params[:page]).per(params[:per]||10)
    respond_with @project, @channels
  end

  def show
    @private_pub_channel = "/projects/#{@project.id}/channels/#{@channel.id}"
    respond_with @project, @channel
  end

  def new
    @form = ChannelOperation::Create.new(current_user, @project)
    respond_with @project, @form
  end

  def create
    @form = ChannelOperation::Create.new(current_user, @project)
    @form.process(params)
    PrivatePub.publish_to("/projects/#{@project.id}/channels", {
      action: 'create',
      target: 'channel',
      data:   private_pub_data
    })
    respond_with @project, @form
  end

  def edit
    @form = ChannelOperation::Update.new(current_user, @project, @channel)
    respond_with @project, @form
  end

  def update
    @form = ChannelOperation::Update.new(current_user, @project, @channel)
    @form.process(params)
    PrivatePub.publish_to("/projects/#{@project.id}/channels/#{@channel.id}", {
      action: 'update',
      target: 'channel',
      data:   private_pub_data
    })
    PrivatePub.publish_to("/projects/#{@project.id}/channels", {
      action: 'update',
      target: 'channel',
      data:   private_pub_data
    })
    respond_with @project, @form
  end

  def destroy
    # @form = ChannelOperation::Destroy.new(current_user, @project, @channel)
    # @form.process
    # PrivatePub.publish_to("/projects/#{@project.id}/channels", {
    #   action: 'destroy',
    #   target: 'channel',
    #   data:   private_pub_data
    # })
    respond_with @project, @form, location: project_dashboard_path(@project)
  end

  def read
    @form = ChannelOperation::Read.new(current_user, resource)
    @form.process(params)

    head :no_content
  end

  def read_status
    res = {}
    channels = @project.channels.where(archived: false)
    participantions = ChannelParticipation.where(channel_id: channels.map(&:id))
                                          .where(user_id: current_user.id)

    channels.each do |channel|
      res[channel.id] = 0
      participantion = participantions.find {|p| p.channel_id == channel.id}

      if participantion && participantion.last_read_floor == channel.max_floor
        res[channel.id] = 1
      end
    end

    respond_with res
  end

  protected

  def private_pub_data
    @form.model.as_json
  end

  def resource
    @channel ||= @project.channels.find_by_slug!( params[:id] )
  end

end
