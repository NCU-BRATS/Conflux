module IssueOperation
  class Update < BaseForm

    def initialize(current_user, project, issue)
      @current_user = current_user
      @project      = project

      super({issue: issue})
    end

    def process(params)
      validate(params[:issue]) && save
      ParticipationOperation::Create.new(@model[:issue].assignee, @model[:issue]).process if @model[:issue].assignee
    end

  end
end
