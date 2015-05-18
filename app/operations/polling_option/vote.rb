class PollingOption < ActiveRecord::Base
  class Vote < Reform::Form

    model :polling_option

    def initialize(current_user, poll, polling_option)
      @current_user   = current_user
      @poll           = poll
      @option         = polling_option
    end

    def process
      if @poll.open?
        unvote_other_options unless @poll.allow_multiple_choice

        if @current_user.voted_as_when_voted_for(@option)
          @option.unliked_by(@current_user)
        else
          @option.liked_by(@current_user)
        end

        Participation::Create.new(@current_user, @poll).process

        @poll.save # trigger sync
        true
      else
        false
      end
    end

    private

    def unvote_other_options
      @poll.options.each {|po| po.unliked_by(@current_user) if po != @option}
    end

  end
end
