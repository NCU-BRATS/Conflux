module SprintOperation
  class Update < BaseForm

    def initialize(current_user, project, sprint)
      @current_user = current_user
      @project      = project

      super(sprint)
    end

    def process(params)
      validate(sprint_params(params)) && save
    end

  end
end
