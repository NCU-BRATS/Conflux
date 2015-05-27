module MessageOperation
  class BaseForm < Reform::Form
    model :message

    property :content, validates: {presence: true}

    private

    def mention_service
      MentionService.new
    end

  end
end
