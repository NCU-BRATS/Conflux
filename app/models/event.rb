class Event < ActiveRecord::Base
  default_scope { where.not(author_id: nil) }

  delegate :name, :email, to: :author, prefix: true, allow_nil: true
  delegate :title, to: :issue, prefix: true, allow_nil: true

  belongs_to :author, class_name: "User"
  belongs_to :project
  belongs_to :target, polymorphic: true

  scope :recent, -> { order("created_at DESC") }
  scope :in_projects, ->(project_ids) { where(project_id: project_ids).recent }

end
