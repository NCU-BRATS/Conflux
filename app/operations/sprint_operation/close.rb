module SprintOperation
  class Close < BaseForm

    def initialize(current_user, project, sprint)
      @current_user = current_user
      @project      = project
      super(sprint)
    end

    def process
      if @model.close!
        BroadcastService.fire(:on_sprint_closed, @model, @current_user)
      end
    end

  end
end
