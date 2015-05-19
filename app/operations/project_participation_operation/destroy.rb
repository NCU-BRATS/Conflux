module ProjectParticipationOperation
  class Destroy < BaseForm

    def initialize(current_user, project, project_participation)
      @current_user = current_user
      @project      = project
      super(project_participation)
    end

    def process
      if @project.project_participations.size > 1
        if @model.destroy
          BroadcastService.fire(:on_project_participation_deleted, @model.to_json, @current_user)
        end
      else
        @model.errors.add(:base, '')
      end
    end

  end
end
