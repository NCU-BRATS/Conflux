class Channel < ActiveRecord::Base
  class BaseForm < Reform::Form
    model :channel

    property :name, validates: {presence: true}
    property :description
    property :announcement

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
