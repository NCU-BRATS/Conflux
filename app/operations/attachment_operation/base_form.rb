module AttachmentOperation
  class BaseForm < Reform::Form

    model :attachment

    property :name
    property :path
    property :path_cache

    validates :name, :path, presence: true

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
