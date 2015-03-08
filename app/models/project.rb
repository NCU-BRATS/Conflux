class Project < ActiveRecord::Base
  include FriendlyId
  extend Enumerize

  sync :all

  friendly_id :name, use: :slugged
  enumerize :visibility_level, in: {private: 0, public: 1}, default: :private, scope: true

  has_many :project_participations, dependent: :destroy
  has_many :members, through: :project_participations, source: :user

  has_many :issues,       dependent: :destroy
  has_many :sprints,      dependent: :destroy
  has_many :repositories, dependent: :destroy
  has_many :labels,       dependent: :destroy
  has_many :events,       dependent: :destroy
  has_many :channels,     dependent: :destroy

  has_many :attachments,  dependent: :destroy
  has_many :posts,        dependent: :destroy
  has_many :images,       dependent: :destroy
  has_many :snippets,     dependent: :destroy
  has_many :other_attachments, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: true

  def has_member?(user)
    members.include? user
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end

end
