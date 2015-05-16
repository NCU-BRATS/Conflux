class ProjectParticipation < ActiveRecord::Base
  class Destroy < BaseForm

    def initialize(current_user, project, project_participation)
      @current_user = current_user
      @project      = project
      super(project_participation)
    end

    def process
      if @project.project_participations.size > 1
        if @model.destroy
          event_service.left_project(@model, @current_user)
        end
      else
        @model.errors.add(:base, '')
      end
    end

  end
end
