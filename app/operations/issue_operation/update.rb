module IssueOperation
  class Update < BaseForm

    def initialize(current_user, project, issue)
      @current_user = current_user
      @project      = project

      super(issue)
    end

    def process(params)
      if validate(issue_params(params)) && sync
        if ( @model.sprint.statuses.map { |status| status['id'].to_s } ).include? @model.status
          if @model.save
            ParticipationOperation::Create.new(@model.assignee, @model).process if @model.assignee
          end
        end
      end
    end

  end
end
