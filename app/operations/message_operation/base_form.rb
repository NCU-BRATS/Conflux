module MessageOperation
  class BaseForm < Reform::Form
    model :message

    property :content, validates: {presence: true}

    def message_params(params)
      params.require(:message)
    end

  end
end
