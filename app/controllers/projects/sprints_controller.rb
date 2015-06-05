class Projects::SprintsController < Projects::ApplicationController

  def index
    @q = @project.sprints.includes(:user).search(params[:q])
    @sprints = @q.result.uniq.page(params[:page]).per(params[:per]||10)
    respond_with @project, @sprints
  end

  def show
    @private_pub_channel1 = "/projects/#{@project.id}/sprints/#{@sprint.sequential_id}"
    @private_pub_channel2 = "/sprint/#{@sprint.id}/comments"
    respond_with @project, @sprint
  end

  def new
    @form = SprintOperation::Create.new(current_user, @project)
    respond_with @project, @form
  end

  def create
    @form = SprintOperation::Create.new(current_user, @project)
    @form.process(params)
    PrivatePub.publish_to( private_pub_channel, {
        action: 'create',
        target: 'sprint',
        data:   private_pub_data
    })
    respond_with @project, @form
  end

  def update
    @form = SprintOperation::Update.new(current_user, @project, @sprint)
    @form.process(params)
    PrivatePub.publish_to( private_pub_channel, {
        action: 'update',
        target: 'sprint',
        data:   private_pub_data
    })
    respond_with @project, @form
  end

  def close
    @form = SprintOperation::Close.new(current_user, @project, @sprint)
    @form.process
    PrivatePub.publish_to( private_pub_channel, {
        action: 'update',
        target: 'sprint',
        data:   private_pub_data
    })
    respond_with @project, @form
  end

  def reopen
    @form = SprintOperation::Reopen.new(current_user, @project, @sprint)
    @form.process
    PrivatePub.publish_to( private_pub_channel, {
        action: 'update',
        target: 'sprint',
        data:   private_pub_data
    })
    respond_with @project, @form
  end

  protected

  def resource
    @sprint ||= @project.sprints.where( :sequential_id => params[:id] ).first
  end

  def private_pub_channel
    @private_pub_channel ||= "/projects/#{@project.id}/sprints/#{@form.model.sequential_id}"
  end

  def private_pub_data
    @form.model.as_json(include: [ :user, :issues, :participations => { include: [ :user ] } ])
  end

end
