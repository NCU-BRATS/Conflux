module PollOperation
  class Create < BaseForm
    property :content, on: :comment
    validates :content, presence: true

    def initialize(current_user, project)
      @current_user = current_user
      @project      = project
      poll          = Poll.new(options: [PollingOption.new])
      comment       = Comment.new
      super({poll: poll, comment: comment})
    end

    def process(params)
      poll, comment = @model[:poll], @model[:comment]
      save do |hash|
        comment.user = @current_user
        poll.user    = @current_user
        poll.project = @project
        poll.comments << comment
        poll.options_attributes = hash[:poll][:options]
        if poll.save
          ParticipationOperation::Create.new(@current_user, poll).process
          event_service.open_poll(poll, @current_user)
          notice_service.open_poll(poll, @current_user)
          mention_service.mention_filter(:html, comment)
        end
      end if validate(params[:poll]) && sync
    end
  end
end
