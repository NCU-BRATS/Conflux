module SnippetOperation
  class BaseForm < Reform::Form
    model :snippet

    property :name, validates: {presence: true}
    property :language, validates: {presence: true}
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
