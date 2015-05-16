class Poll < ActiveRecord::Base
  class Close < BaseForm

    def initialize(current_user, poll)
      @current_user = current_user
      @poll         = poll
    end

    def process
      if @poll.close!
        event_service.close_poll(@poll, @current_user)
        notice_service.close_poll(@poll, @current_user)
      end
    end

  end
end
