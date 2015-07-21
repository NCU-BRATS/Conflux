module ProjectRoleOperation
  class Create < BaseForm

    def initialize(current_user, project, project_role=ProjectRole.new)
      @current_user = current_user
      @project      = project
      super(project_role)
    end

    def process(params)
      if validate(project_role_params(params)) && sync
        @model.project = @project
        @model.save
      end
    end

  end
end
