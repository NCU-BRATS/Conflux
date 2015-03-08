class Event < ActiveRecord::Base
  default_scope { where.not(author_id: nil) }

  enum action: [ :created, :updated, :closed, :reopened, :commented, :joined, :left, :uploaded, :deleted ]

  delegate :name, :email, to: :author, prefix: true, allow_nil: true
  delegate :title, to: :issue, prefix: true, allow_nil: true
  delegate :title, to: :comment, prefix: true, allow_nil: true

  belongs_to :author, class_name: 'User'
  belongs_to :project
  belongs_to :target, polymorphic: true

  scope :recent, -> { order('created_at DESC') }
  scope :in_projects, ->(project_ids) { where(project_id: project_ids).recent }

  def sprint?
    target_type == 'Sprint'
  end

  def issue?
    target_type == 'Issue'
  end

  def comment?
    target_type == 'Comment'
  end

  def attachment?
    Attachment.subclasses.map(&:name).include?(target_type)
  end

  def target_obj
    target_type.constantize.new(target_json)
  end

end
