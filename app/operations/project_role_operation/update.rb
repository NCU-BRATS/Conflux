module ProjectRoleOperation
  class Update < BaseForm

    def initialize(current_user, project, project_role)
      @current_user = current_user
      @project      = project
      super(project_role)
    end

    def process(params)
      validate(project_role_params(params)) && save
    end

  end
end
