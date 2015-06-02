module PollingOptionOperation
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
        if @option.voted_by?(@current_user)
          @option.unvoted_by(@current_user)
        else
          @option.voted_by(@current_user)
          ParticipationOperation::Create.new(@current_user, @poll).process
        end
        @option.save
        true
      else
        false
      end
    end

    private

    def unvote_other_options
      @poll.options.each do |po|
        po.unvoted_by(@current_user) && po.save if po != @option
      end
    end

  end
end
