module MessageOperation
  class BaseForm < Reform::Form
    model :message

    property :content, validates: {presence: true}

    private

  end
end
