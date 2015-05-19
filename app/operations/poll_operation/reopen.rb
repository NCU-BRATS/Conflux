module PollOperation
  class Reopen < BaseForm

    def initialize(current_user, poll)
      @current_user = current_user
      @poll         = poll
    end

    def process
      if @poll.reopen!
        BroadcastService.fire(:on_poll_reopened, @poll, @current_user)
        notice_service.reopen_poll(@poll, @current_user)
      end
    end

  end
end
