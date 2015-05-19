module IssueOperation
  class Close < BaseForm

    def initialize(current_user, project, issue)
      @current_user = current_user
      @project      = project
      @issue        = issue
    end

    def process
      if @issue.close!
        BroadcastService.fire(:on_issue_closed, @issue, @current_user)
        notice_service.close_issue(@issue, @current_user)
      end
    end

  end
end
