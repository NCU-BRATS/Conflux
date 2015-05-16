class ProjectParticipation < ActiveRecord::Base
  class BaseForm < Reform::Form

    model :project_participation

    property :project_role_id

    private

    def event_service
      EventCreateService.new
    end

    def notice_service
      NoticeCreateService.new
    end

    def mention_service
      MentionService.new
    end

  end
end
