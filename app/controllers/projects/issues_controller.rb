class Projects::IssuesController < Projects::ApplicationController

  def index
    @q = @project.issues.includes(:user, :assignee, :labels).order('id DESC').search( params[:q] )
    @issues = @q.result.uniq.page( params[:page] ).per( params[:per] || 10 )
    respond_with @project, @issues
  end

  def show
    respond_with @project, @issue
  end

  def participations
    respond_with @project, @issue
  end

  def comments
    respond_with @project, @issue
  end

  def new
    @form = IssueOperation::Create.new(current_user, @project)
    respond_with @project, @form
  end

  def create
    @form = IssueOperation::Create.new(current_user, @project)
    @form.process(params)
    PrivatePub.publish_to( private_pub_channel, {
         action: 'create',
         target: 'issue',
         data:   private_pub_data
     })
    respond_with @project, @form
  end

  def update
    @form = IssueOperation::Update.new(current_user, @project, @issue)
    @form.process(params)
    PrivatePub.publish_to( private_pub_channel, {
         action: 'update',
         target: 'issue',
         data:   private_pub_data
     })
    respond_with @project, @form
  end

  protected

  def resource
    @issue ||= @project.issues.includes( participations: :user ).where( :sequential_id => params[:id] ).first
  end

  def private_pub_channel
    @private_pub_channel ||= "/projects/#{@project.id}/issues"
  end

  def private_pub_data
    @form.model.as_json(include: [ :user, :sprint, :assignee, :labels ])
  end

end
