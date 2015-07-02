module CommentOperation
  class BaseForm < Reform::Form
    model :comment

    property :content, validates: {presence: true}

    def comment_params(params)
      params.require(:comment)
    end

  end
end
