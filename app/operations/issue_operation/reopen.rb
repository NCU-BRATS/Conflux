module IssueOperation
  class Reopen < BaseForm

    def initialize(current_user, project, issue)
      @current_user = current_user
      @project      = project
      super(issue)
    end

    def process
      if @model.reopen!
        BroadcastService.fire(:on_issue_reopened, @model, @current_user)
      end
    end

  end
end
