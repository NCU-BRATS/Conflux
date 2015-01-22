class Projects::SprintsController < Projects::ApplicationController
  enable_sync only: [:create, :update, :close, :reopen]
  before_action :authenticate_user!
  before_action :set_sprint, only: [ :show, :update, :close, :reopen ]

  def index
    @q  = @project.sprints.includes(:user).search(params[:q])
    @sprints = @q.result.uniq.page(params[:page]).per(params[:per])
    respond_with @project, @sprints
  end

  def show
    respond_with @project, @sprint
  end

  def new
    @sprint = @project.sprints.build
    @sprint.comments.build
    authorize @sprint
    respond_with @project, @sprint
  end

  def create
    @sprint = @project.sprints.build( sprint_params )
    @sprint.user = current_user
    @sprint.comments.each { |comment| comment.user = current_user }
    @sprint.save
    respond_with @project, @sprint
  end

  def update
    @sprint.update( sprint_params )
    respond_with @project, @sprint
  end

  def close
    @sprint.close!
  end

  def reopen
    @sprint.reopen!
  end

  private

  def set_sprint
    @sprint = @project.sprints.where( :sequential_id => params[:id] ).first
  end

  def sprint_params
    params.require(:sprint).permit( :title, :begin_at, :due_at, :status, comments_attributes: [ :content ] )
  end

end
