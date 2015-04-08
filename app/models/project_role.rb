class ProjectRole < ActiveRecord::Base

  belongs_to :project

  validates :project, presence: true
  validates :name, presence: true

end
