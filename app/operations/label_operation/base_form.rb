module LabelOperation
  class BaseForm < Reform::Form
    extend ActiveModel::ModelValidations
    model :label

    property :title
    property :color

    copy_validations_from Label

    def label_params(params)
      params.require(:label)
    end

  end
end
