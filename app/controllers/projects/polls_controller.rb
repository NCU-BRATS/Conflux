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
    @poll = @project.polls.build
    @poll.options.build
    @poll.comments.build
    respond_with @project, @poll
  end

  def create
    @poll = @project.polls.build(poll_params)
    @poll.user = current_user
    @poll.comments.each { |comment| comment.user = current_user }
    @poll.save
    respond_with @project, @poll
  end

  def update
    @poll.update(poll_params)
    respond_with @project, @poll
  end

  def close
    @poll.close!
    # if @poll.close!
    #   event_service.close_poll(@poll, current_user)
    # end
    respond_with @project, @poll
  end

  def reopen
    @poll.reopen!
    # if @poll.reopen!
    #   event_service.reopen_poll(@poll, current_user)
    # end
    respond_with @project, @poll
  end

  protected

  def resource
    @poll ||= @project.polls.where(:sequential_id => params[:id]).first
  end

  def poll_params
    params.require(:poll).permit(:title, :status, :allow_multiple_choice, comments_attributes: [ :content ], options_attributes: [:id, :_destroy, :title] )
  end

end
