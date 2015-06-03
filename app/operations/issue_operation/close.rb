module IssueOperation
  class Close < BaseForm

    def initialize(current_user, project, issue)
      @current_user = current_user
      @project      = project
      super(issue)
    end

    def process
      if @model.close!
        BroadcastService.fire(:on_issue_closed, @model, @current_user)
      end
    end

  end
end
