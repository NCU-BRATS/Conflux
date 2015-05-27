module SprintOperation
  class Reopen < BaseForm

    def initialize(current_user, project, sprint)
      @current_user = current_user
      @project      = project
      @sprint        = sprint
    end

    def process
      if @sprint.reopen!
        BroadcastService.fire(:on_sprint_reopened, @sprint, @current_user)
      end
    end

  end
end
