class Projects::PollsController < Projects::ApplicationController

  enable_sync only: [:create, :update, :close, :reopen]

  def index
    @q = @project.polls.includes(:user).order('id DESC').search(params[:q])
    @polls = @q.result.uniq.page(params[:page]).per(params[:per])
    respond_with @project, @polls
  end

  def show
    respond_with @project, @poll
  end

  def new
    @form = PollOperation::Create.new(current_user, @project)
    respond_with @project, @form
  end

  def create
    @form = PollOperation::Create.new(current_user, @project)
    @form.process(params)
    respond_with @project, @form
  end

  def update
    @form = PollOperation::Update.new(current_user, @poll)
    @form.process(params)
    respond_with @project, @form
  end

  def close
    @form = PollOperation::Close.new(current_user, @poll)
    @form.process
    respond_with @project, @form
  end

  def reopen
    @form = PollOperation::Reopen.new(current_user, @poll)
    @form.process
    respond_with @project, @form
  end

  protected

  def resource
    @poll ||= @project.polls.where(:sequential_id => params[:id]).first
  end

end
