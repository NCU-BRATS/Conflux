module PostOperation
  class BaseForm < Reform::Form
    model :post

    property :name, validates: {presence: true}
    property :content, validates: {presence: true}

    private

  end
end
