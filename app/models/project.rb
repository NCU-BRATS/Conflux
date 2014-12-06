class Project < ActiveRecord::Base
  has_many :project_participations
  has_many :users, through: :project_participations

  has_many :issues
  has_many :sprints
  has_many :repositories

  validates :name, presence: true
end
