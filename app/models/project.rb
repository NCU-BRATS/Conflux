class Project < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, use: :slugged

  has_many :project_participations, dependent: :destroy
  has_many :users, through: :project_participations

  has_many :issues,       dependent: :destroy
  has_many :sprints,      dependent: :destroy
  has_many :repositories, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: true

  def should_generate_new_friendly_id?
    name_changed? || super
  end
end
