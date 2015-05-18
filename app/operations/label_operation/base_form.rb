module LabelOperation
  class BaseForm < Reform::Form
    model :label

    property :title, validates: {presence: true}
    property :color

  end
end
