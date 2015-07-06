module PostOperation
  class BaseForm < Reform::Form
    model :post

    property :name, validates: {presence: true}
    property :content, validates: {presence: true}

    def post_params(params)
      params.require(:post)
    end

  end
end
