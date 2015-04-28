class Projects::PollingOptionsController < Projects::ApplicationController

  enable_sync only: [:update]

  def update
    if @poll.open?
      unvote_other_options unless @poll.allow_multiple_choice

      if current_user.voted_as_when_voted_for(@option)
        @option.unliked_by(current_user)
      else
        @option.liked_by(current_user)
      end

      participate_poll

      @poll.save # trigger sync
    else
      flash.now[:alert] = t('poll.alert')
    end

    respond_with @project, @option
  end

  protected

  def resource
    @poll ||= @project.polls.where(sequential_id: params[:poll_id]).first
    @options ||= @poll.options
    @option  ||= @options.find {|po| po.id == params[:id].to_i}
  end

  def unvote_other_options
    @options.each {|po| po.unliked_by(current_user) if po != @option}
  end

  def participate_poll
    if !@poll.participations.exists?(user_id: current_user.id)
      @poll.participations.create(user: current_user)
    end
  end

end
