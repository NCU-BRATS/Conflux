module SprintOperation
  class Close < BaseForm

    def initialize(current_user, project, sprint)
      @current_user = current_user
      @project      = project
      @sprint        = sprint
    end

    def process
      if @sprint.close!
        BroadcastService.fire(:on_sprint_closed, @sprint, @current_user)
      end
    end

  end
end
