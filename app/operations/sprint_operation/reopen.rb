module SprintOperation
  class Reopen < BaseForm

    def initialize(current_user, project, sprint)
      @current_user = current_user
      @project      = project
      super(sprint)
    end

    def process
      if @model.reopen!
        BroadcastService.fire(:on_sprint_reopened, @model, @current_user)
      end
    end

  end
end
