class ProjectRole < ActiveRecord::Base
  class Update < BaseForm

    def initialize(current_user, project, project_role)
      @current_user = current_user
      @project      = project
      super(project_role)
    end

    def process(params)
      validate(params[:project_role]) && save
    end

  end
end
