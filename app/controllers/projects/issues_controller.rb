class Projects::IssuesController < Projects::ApplicationController

  enable_sync only: [:create, :update, :close, :reopen]

  def index
    @q = @project.issues.includes(:user, :assignee, :labels).order('id DESC').search( params[:q] )
    @issues = @q.result.uniq.page( params[:page] ).per( params[:per] || 10 )
    respond_with @project, @issues
  end

  def show
    @private_pub_channel1 = "/projects/#{@project.id}/issues/#{@issue.sequential_id}"
    @private_pub_channel2 = "/issue/#{@issue.id}/comments"
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

  def close
    @form = IssueOperation::Close.new(current_user, @project, @issue)
    @form.process
    PrivatePub.publish_to( private_pub_channel, {
         action: 'update',
         target: 'issue',
         data:   private_pub_data
     })
    respond_with @project, @form
  end

  def reopen
    @form = IssueOperation::Reopen.new(current_user, @project, @issue)
    @form.process
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
    @private_pub_channel ||= "/projects/#{@project.id}/issues/#{@form.model.sequential_id}"
  end

  def private_pub_data
    @form.model.as_json(include: [ :user, :sprint, :assignee, :labels, :participations => { include: [ :user ] } ])
  end

end
