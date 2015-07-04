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
      sprint_params = sprint_params(params)
      if validate(sprint_params.except(:issue_ids)) && sync
        @model.user   = @current_user
        @model.project = @project
        if @model.save
          @model.update_attributes(issue_ids: sprint_params[:issue_ids])

          comment_param = ActionController::Parameters.new({comment: {content: sprint_params[:content]}})
          CommentOperation::Create.new(@current_user, @model).process(comment_param)

          ParticipationOperation::Create.new(@current_user, @model).process
          BroadcastService.fire(:on_sprint_created, @model, @current_user)
        end
      end
    end
  end
end
