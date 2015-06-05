module PollOperation
  class Reopen < BaseForm

    def initialize(current_user, poll)
      @current_user = current_user
      super(poll)
    end

    def process
      if @model.reopen!
        BroadcastService.fire(:on_poll_reopened, @model, @current_user)
      end
    end

  end
end
