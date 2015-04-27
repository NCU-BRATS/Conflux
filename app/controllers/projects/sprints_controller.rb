class Projects::SprintsController < Projects::ApplicationController

  enable_sync only: [:create, :update, :close, :reopen]

  def index
    @q = @project.sprints.includes(:user).search(params[:q])
    @sprints = @q.result.uniq.page(params[:page]).per(params[:per])
    respond_with @project, @sprints
  end

  def show
    respond_with @project, @sprint
  end

  def new
    @sprint = @project.sprints.build
    @sprint.comments.build
    respond_with @project, @sprint
  end

  def create
    @sprint = @project.sprints.build( sprint_params.except(:issue_ids) )
    @sprint.user = current_user
    @sprint.comments.each { |comment| comment.user = current_user }
    if @sprint.save
      issue_params = sprint_params[:issue_ids]
      @sprint.update_attributes(issue_ids: issue_params)
      event_service.open_sprint(@sprint, current_user)
      notice_service.open_sprint(@sprint, current_user)
    end
    respond_with @project, @sprint
  end

  def update
    @sprint.update( sprint_params )
    respond_with @project, @sprint
  end

  def close
    if @sprint.close!
      event_service.close_sprint(@sprint, current_user)
      notice_service.close_sprint(@sprint, current_user)
    end
  end

  def reopen
    if @sprint.reopen!
      event_service.reopen_sprint(@sprint, current_user)
      notice_service.reopen_sprint(@sprint, current_user)
    end
  end

  protected

  def resource
    @sprint ||= @project.sprints.where( :sequential_id => params[:id] ).first
  end

  def sprint_params
    params.require(:sprint).permit( :title, :begin_at, :due_at, :status, issue_ids:[], comments_attributes: [ :content ] )
  end

end
