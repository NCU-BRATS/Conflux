module SnippetOperation
  class BaseForm < Reform::Form
    model :snippet

    property :name, validates: {presence: true}
    property :language, validates: {presence: true}
    property :content, validates: {presence: true}

    private

  end
end
