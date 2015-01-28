class Projects::IssuesController < Projects::ApplicationController

  enable_sync only: [:create, :update, :close, :reopen]

  def index
    @q = @project.issues.includes(:user, :assignee, :labels).order('id DESC').search( params[:q] )
    @issues = @q.result.uniq.page( params[:page] ).per( params[:per] )
    respond_with @project, @issue
  end

  def show
    respond_with @project, @issue
  end

  def new
    @issue = @project.issues.build
    @issue.comments.build
    respond_with @project, @issue
  end

  def create
    @issue = @project.issues.build( issue_params.except(:label_ids) )
    @issue.user = current_user
    @issue.comments.each { |comment| comment.user = current_user }
    @issue.save
    label_params = issue_params[:label_ids]
    @issue.update_attributes(label_ids: label_params)
    respond_with @project, @issue
  end

  def update
    @issue.update( issue_params )
    respond_with @project, @issue
  end

  def close
    @issue.close!
  end

  def reopen
    @issue.reopen!
  end

  protected

  def set_resourse
    @issue = @project.issues.where( :sequential_id => params[:id] ).first
  end

  def issue_params
    params.require(:issue).permit( :title, :begin_at, :due_at, :status, :assignee_id, :sprint_id, comments_attributes: [ :content ], label_ids: [] )
  end

end
