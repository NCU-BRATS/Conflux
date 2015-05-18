module MessageOperation
  class BaseForm < Reform::Form
    model :message

    property :content, validates: {presence: true}

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
