class Projects::SprintsController < Projects::ApplicationController

  enable_sync only: [:create, :update, :close, :reopen]

  def index
    @q = @project.sprints.includes(:user).search(params[:q])
    @sprints = @q.result.uniq.page(params[:page]).per(params[:per]||10)
    respond_with @project, @sprints
  end

  def show
    respond_with @project, @sprint
  end

  def new
    @form = Sprint::Create.new(current_user, @project)
    respond_with @project, @form
  end

  def create
    @form = Sprint::Create.new(current_user, @project)
    @form.process(params)
    respond_with @project, @form
  end

  def update
    @form = Sprint::Update.new(current_user, @project, @sprint)
    @form.process(params)
    respond_with @project, @form
  end

  def close
    @form = Sprint::Close.new(current_user, @project, @sprint)
    @form.process
    respond_with @project, @form
  end

  def reopen
    @form = Sprint::Reopen.new(current_user, @project, @sprint)
    @form.process
    respond_with @project, @form
  end

  protected

  def resource
    @sprint ||= @project.sprints.where( :sequential_id => params[:id] ).first
  end

end
