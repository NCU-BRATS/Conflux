class Project < ActiveRecord::Base
  class BaseForm < Reform::Form
    include Reform::Form::ActiveModel
    include Reform::Form::ActiveModel::FormBuilderMethods

    model :project

    property :name
    property :visibility_level
    property :description

    validates :name, :visibility_level, presence: true

  end
end
