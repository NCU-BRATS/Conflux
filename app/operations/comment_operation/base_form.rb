module CommentOperation
  class BaseForm < Reform::Form
    model :comment

    property :content, validates: {presence: true}

    private

  end
end
