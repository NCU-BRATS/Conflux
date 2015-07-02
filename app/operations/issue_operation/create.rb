module IssueOperation
  class Create < BaseForm
    property :content, virtual: true
    validates :content, presence: true

    def initialize(current_user, project)
      @current_user = current_user
      @project      = project
      super(Issue.new)
    end

    def process(params)
      issue_params = issue_params(params)
      if validate( issue_params.except(:label_ids) ) && sync
        @model.user    = @current_user
        @model.project = @project
        if @model.save
          @model.update_attributes(label_ids: issue_params[:label_ids])

          comment_param = ActionController::Parameters.new({comment: {content: issue_params[:content]}})
          CommentOperation::Create.new(@current_user, @model).process(comment_param)

          ParticipationOperation::Create.new(@current_user, @model).process
          ParticipationOperation::Create.new(@model.assignee, @model).process if @model.assignee
          BroadcastService.fire(:on_issue_created, @model, @current_user)
        end
      end
    end
  end
end
