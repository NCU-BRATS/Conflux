module PollOperation
  class Close < BaseForm

    def initialize(current_user, poll)
      @current_user = current_user
      super(poll)
    end

    def process
      if @model.close!
        BroadcastService.fire(:on_poll_closed, @model, @current_user)
      end
    end

  end
end
