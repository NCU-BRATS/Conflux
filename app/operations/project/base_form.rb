class Project < ActiveRecord::Base
  class BaseForm < Reform::Form
    model :project

    property :name
    property :visibility_level
    property :description

    validates :name, :visibility_level, presence: true
    validates_uniqueness_of :name

  end
end
