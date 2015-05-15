class Project < ActiveRecord::Base
  class Destroy < BaseForm

    def initialize(current_user, project)
      @current_user = current_user
      super(project)
    end

    def process
      @model.destroy
    end

  end
end
