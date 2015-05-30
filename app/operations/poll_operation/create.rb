module PollOperation
  class Create < BaseForm
    property :content, virtual: true
    validates :content, presence: true

    def initialize(current_user, project)
      @current_user = current_user
      @project      = project
      poll          = Poll.new(options: [PollingOption.new])
      super(poll)
    end

    def process(params)
      save do |hash|
        @model.user    = @current_user
        @model.project = @project
        @model.options_attributes = hash[:options]
        if @model.save
          comment_param = ActionController::Parameters.new({comment: {content: params[:poll][:content]}})
          CommentOperation::Create.new(@current_user, @model).process(comment_param)

          ParticipationOperation::Create.new(@current_user, @model).process
          BroadcastService.fire(:on_poll_created, @model, @current_user)
        end
      end if validate(params[:poll]) && sync
    end
  end
end
