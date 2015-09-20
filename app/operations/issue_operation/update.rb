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
          status_changed = @model.status_changed?
          status_was     = @model.status_was
          if @model.save
            ParticipationOperation::Create.new(@model.assignee, @model).process if @model.assignee
            if status_changed
              if status_was == '2'
                BroadcastService.fire(:on_issue_reopened, @model, @current_user)
              elsif @model.status == '2'
                BroadcastService.fire(:on_issue_closed, @model, @current_user)
              end
            end
          end
        end
      end
    end

  end
end
