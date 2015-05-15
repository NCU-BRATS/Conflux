class Projects::ChannelsController < Projects::ApplicationController

  enable_sync only: [:create, :update, :destroy]

  def show
    @messages = @channel.messages.includes(:user).order('id desc').limit(20).search(params[:q]).result.reverse
    respond_with @project, @channel
  end

  def new
    @form = Channel::Create.new(current_user, @project)
    respond_with @project, @form
  end

  def create
    @form = Channel::Create.new(current_user, @project)
    @form.process(params)
    respond_with @project, @form
  end

  def edit
    @form = Channel::Update.new(current_user, @project, @channel)
    respond_with @project, @form
  end

  def update
    @form = Channel::Update.new(current_user, @project, @channel)
    @form.process(params)
    respond_with @project, @form
  end

  def destroy
    @form = Channel::Destroy.new(current_user, @project, @channel)
    @form.process
    respond_with @project, @form, location: project_dashboard_path(@project)
  end

  protected

  def resource
    @channel ||= Channel.friendly.find( params[:id] )
  end

  def channel_params
    params.require( :channel ).permit( :name, :description, :announcement )
  end

end
