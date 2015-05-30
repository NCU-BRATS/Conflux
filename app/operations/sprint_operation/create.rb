module SprintOperation
  class Create < BaseForm
    property :content, virtual: true
    validates :content, presence: true

    def initialize(current_user, project)
      @current_user = current_user
      @project      = project
      super(Sprint.new)
    end

    def process(params)
      if validate(params[:sprint].except(:issue_ids)) && sync
        @model.user   = @current_user
        @model.project = @project
        if @model.save
          @model.update_attributes(issue_ids: params[:sprint][:issue_ids])

          comment_param = ActionController::Parameters.new({comment: {content: params[:sprint][:content]}})
          CommentOperation::Create.new(@current_user, @model).process(comment_param)

          ParticipationOperation::Create.new(@current_user, @model).process
          BroadcastService.fire(:on_sprint_created, @model, @current_user)
        end
      end
    end
  end
end
