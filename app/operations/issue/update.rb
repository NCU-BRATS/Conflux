class Issue < ActiveRecord::Base
  class Update < BaseForm

    def initialize(current_user, project, issue)
      @current_user = current_user
      @project      = project

      super({issue: issue})
    end

    def process(params)
      validate(params[:issue]) && save
    end

  end
end
