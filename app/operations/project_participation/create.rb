class ProjectParticipation < ActiveRecord::Base
  class Create < BaseForm

    property :user_id, validates: {presence: true}

    def initialize(current_user, project, project_participation=ProjectParticipation.new)
      @current_user = current_user
      @project      = project
      super(project_participation)
    end

    def process(params)
      if validate(params[:project_participation]) && sync
        @model.project = @project
        if @model.save
          event_service.join_project(@model, @current_user)
        end
      end
    end

  end
end
