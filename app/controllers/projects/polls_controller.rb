class Projects::PollsController < Projects::ApplicationController

  def index
    @q = @project.polls.includes(:user).includes(:options).order('id DESC').search(params[:q])
    @polls = @q.result.uniq.page(params[:page]).per(params[:per])
    respond_with @project, @polls
  end

  def show
    @private_pub_channel1 = "/projects/#{@project.id}/polls/#{@poll.sequential_id}"
    @private_pub_channel2 = "/poll/#{@poll.id}/comments"
    respond_with @project, @poll
  end

  def new
    @form = PollOperation::Create.new(current_user, @project)
    respond_with @project, @form
  end

  def create
    @form = PollOperation::Create.new(current_user, @project)
    @form.process(params)
    respond_with @project, @form
  end

  def update
    @form = PollOperation::Update.new(current_user, @poll)
    @form.process(params)
    PrivatePub.publish_to( private_pub_channel, {
         action: 'update',
         target: 'poll',
         data:   private_pub_data
     })
    respond_with @project, @form
  end

  def close
    @form = PollOperation::Close.new(current_user, @poll)
    @form.process
    PrivatePub.publish_to( private_pub_channel, {
         action: 'update',
         target: 'poll',
         data:   private_pub_data
     })
    respond_with @project, @form
  end

  def reopen
    @form = PollOperation::Reopen.new(current_user, @poll)
    @form.process
    PrivatePub.publish_to( private_pub_channel, {
         action: 'update',
         target: 'poll',
         data:   private_pub_data
     })
    respond_with @project, @form
  end

  protected

  def resource
    @poll ||= @project.polls.where(:sequential_id => params[:id]).first
  end

  def private_pub_channel
    @private_pub_channel ||= "/projects/#{@project.id}/polls/#{@form.model.sequential_id}"
  end

  def private_pub_data
    @form.model.as_json(include: [ :user, :options, :participations => { include: [ :user ] } ])
  end

end
