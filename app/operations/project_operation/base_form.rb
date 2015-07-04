module ProjectOperation
  class BaseForm < Reform::Form
    extend ActiveModel::ModelValidations
    model :project

    property :name
    property :visibility_level
    property :description

    copy_validations_from Project

    def project_params(params)
      params.require(:project)
    end

  end
end
