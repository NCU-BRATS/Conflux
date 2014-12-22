class Project < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, use: :slugged

  has_many :project_participations, dependent: :destroy
  has_many :members, through: :project_participations, source: :user

  has_many :issues,       dependent: :destroy
  has_many :sprints,      dependent: :destroy
  has_many :repositories, dependent: :destroy

  sync :all

  validates :name, presence: true
  validates :name, uniqueness: true

  def is_memeber?(user)
    members.include? user
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end
end
