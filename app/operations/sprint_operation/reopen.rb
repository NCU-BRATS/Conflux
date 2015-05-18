module SprintOperation
  class Reopen < BaseForm

    def initialize(current_user, project, sprint)
      @current_user = current_user
      @project      = project
      @sprint        = sprint
    end

    def process
      if @sprint.reopen!
        event_service.reopen_sprint(@sprint, @current_user)
        notice_service.reopen_sprint(@sprint, @current_user)
      end
    end

  end
end
