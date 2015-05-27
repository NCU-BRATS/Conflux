module CommentOperation
  class BaseForm < Reform::Form
    model :comment

    property :content, validates: {presence: true}

    private

    def mention_service
      MentionService.new
    end

  end
end
