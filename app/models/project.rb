class Project < ActiveRecord::Base
  include FriendlyId

  sync :all

  friendly_id :name, use: :slugged

  has_many :project_participations, dependent: :destroy
  has_many :members, through: :project_participations, source: :user

  has_many :issues,       dependent: :destroy
  has_many :sprints,      dependent: :destroy
  has_many :repositories, dependent: :destroy
  has_many :labels,       dependent: :destroy
  has_many :events,       dependent: :destroy

  has_many :attachments,  dependent: :destroy
  has_many :posts,        dependent: :destroy, class_name: 'Attachment::Post'
  has_many :images,       dependent: :destroy, class_name: 'Attachment::Image'
  has_many :snippets,     dependent: :destroy, class_name: 'Attachment::Snippet'
  has_many :other_attachments, dependent: :destroy, class_name: 'Attachment::Other'

  validates :name, presence: true
  validates :name, uniqueness: true

  def has_member?(user)
    members.include? user
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end

end
