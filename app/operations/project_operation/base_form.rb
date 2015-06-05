module ProjectOperation
  class BaseForm < Reform::Form
    extend ActiveModel::ModelValidations
    model :project

    property :name
    property :visibility_level
    property :description

    copy_validations_from Project

  end
end
