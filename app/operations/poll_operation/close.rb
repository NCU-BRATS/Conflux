module PollOperation
  class Close < BaseForm

    def initialize(current_user, poll)
      @current_user = current_user
      @poll         = poll
    end

    def process
      if @poll.close!
        BroadcastService.fire(:on_poll_closed, @poll, @current_user)
      end
    end

  end
end
