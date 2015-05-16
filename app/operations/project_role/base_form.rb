class ProjectRole < ActiveRecord::Base
  class BaseForm < Reform::Form

    model :project_role

    property :name

    validates :name, presence: true

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
