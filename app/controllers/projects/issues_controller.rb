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
    @form = IssueOperation::Create.new(current_user, @project)
    respond_with @project, @form
  end

  def create
    @form = IssueOperation::Create.new(current_user, @project)
    @form.process(params)
    respond_with @project, @form
  end

  def update
    @form = IssueOperation::Update.new(current_user, @project, @issue)
    @form.process(params)
    respond_with @project, @form
  end

  def close
    @form = IssueOperation::Close.new(current_user, @project, @issue)
    @form.process
    respond_with @project, @form
  end

  def reopen
    @form = IssueOperation::Reopen.new(current_user, @project, @issue)
    @form.process
    respond_with @project, @form
  end

  protected

  def resource
    @issue ||= @project.issues.where( :sequential_id => params[:id] ).first
  end

end
