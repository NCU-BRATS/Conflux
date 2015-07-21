module ProjectParticipationOperation
  class Update < BaseForm

    def initialize(current_user, project, project_participation)
      @current_user = current_user
      @project      = project
      super(project_participation)
    end

    def process(params)
      validate(project_participation_params(params)) && save
    end

  end
end
