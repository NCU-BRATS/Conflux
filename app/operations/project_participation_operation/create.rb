module ProjectParticipationOperation
  class Create < BaseForm

    property :user_id, validates: {presence: true}

    def initialize(current_user, project, project_participation=ProjectParticipation.new)
      @current_user = current_user
      @project      = project
      super(project_participation)
    end

    def process(params)
      if validate(project_participation_params(params)) && sync
        @model.project = @project
        if @model.save
          BroadcastService.fire(:on_project_participation_created, @model, @current_user)
        end
      end
    end

  end
end
