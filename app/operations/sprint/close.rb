class Sprint < ActiveRecord::Base
  class Close < BaseForm

    def initialize(current_user, project, sprint)
      @current_user = current_user
      @project      = project
      @sprint        = sprint
    end

    def process
      if @sprint.close!
        event_service.close_sprint(@sprint, @current_user)
        notice_service.close_sprint(@sprint, @current_user)
      end
    end

  end
end
