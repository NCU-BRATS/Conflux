module ProjectParticipationOperation
  class Update < BaseForm

    def initialize(current_user, project, project_participation)
      @current_user = current_user
      @project      = project
      super(project_participation)
    end

    def process(params)
      validate(params[:project_participation]) && save
    end

  end
end
