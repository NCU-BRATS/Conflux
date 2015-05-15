class Projects::IssuesController < Projects::ApplicationController

  enable_sync only: [:create, :update, :close, :reopen]

  def index
    @q = @project.issues.includes(:user, :assignee, :labels).order('id DESC').search( params[:q] )
    @issues = @q.result.uniq.page( params[:page] ).per( params[:per] || 10 )
    respond_with @project, @issues
  end

  def show
    respond_with @project, @issue
  end

  def new
    @form = Issue::Create.new(current_user, @project)
    respond_with @project, @form
  end

  def create
    @form = Issue::Create.new(current_user, @project)
    @form.process(params)
    respond_with @project, @form
  end

  def update
    @form = Issue::Update.new(current_user, @project, @issue)
    @form.process(params)
    respond_with @project, @form
  end

  def close
    @form = Issue::Close.new(current_user, @project, @issue)
    @form.process
    respond_with @project, @form
  end

  def reopen
    @form = Issue::Reopen.new(current_user, @project, @issue)
    @form.process
    respond_with @project, @form
  end

  protected

  def resource
    @issue ||= @project.issues.where( :sequential_id => params[:id] ).first
  end

  def issue_params
    params.require(:issue).permit( :title, :begin_at, :due_at, :status, :assignee_id, :sprint_id, comments_attributes: [ :content ], label_ids: [] )
  end

end
