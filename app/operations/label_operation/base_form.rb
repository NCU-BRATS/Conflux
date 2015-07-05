module LabelOperation
  class BaseForm < Reform::Form
    model :label

    property :title, validates: {presence: true}
    property :color

    def label_params(params)
      params.require(:label)
    end

  end
end
