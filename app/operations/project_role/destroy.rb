class ProjectRole < ActiveRecord::Base
  class Destroy < BaseForm

    def initialize(current_user, project, project_role)
      @current_user = current_user
      @project      = project
      super(project_role)
    end

    def process
      @model.destroy
    end

  end
end
