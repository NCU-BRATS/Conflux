module IssueOperation
  class Update < BaseForm

    def initialize(current_user, project, issue)
      @current_user = current_user
      @project      = project

      super(issue)
    end

    def process(params)
      validate(issue_params(params)) && save
      ParticipationOperation::Create.new(@model.assignee, @model).process if @model.assignee
    end

  end
end
