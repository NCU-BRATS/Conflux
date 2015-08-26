class Projects::SprintsController < Projects::ApplicationController

  def index
    @q = @project.sprints.includes(:user).search(params[:q])
    @sprints = @q.result.uniq.page(params[:page]).per(params[:per]||10)
    @private_pub_channel1 = "/projects/#{@project.id}/sprints"
    @private_pub_channel2 = "/projects/#{@project.id}/issues"
    @private_pub_channel3 = '/issue/comments'
    respond_with @project, @sprints
  end

  def show
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

  protected

  def resource
    @sprint ||= @project.sprints.where( :sequential_id => params[:id] ).first
  end

  def private_pub_channel
    @private_pub_channel ||= "/projects/#{@project.id}/sprints"
  end

  def private_pub_data
    data = @form.model.as_json(include: [ :user ])
    data[:issues_done_count] = @form.model.issues.where(status:@form.model.statuses[-1]['id']).count
    data
  end

end
