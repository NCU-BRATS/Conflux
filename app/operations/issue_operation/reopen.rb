module IssueOperation
  class Reopen < BaseForm

    def initialize(current_user, project, issue)
      @current_user = current_user
      @project      = project
      @issue        = issue
    end

    def process
      if @issue.reopen!
        BroadcastService.fire(:on_issue_reopened, @issue, @current_user)
      end
    end

  end
end
