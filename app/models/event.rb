class Event < ActiveRecord::Base
  default_scope { where.not(author_id: nil) }

  CREATED   = 1
  UPDATED   = 2
  CLOSED    = 3
  REOPENED  = 4
  COMMENTED = 5
  JOINED    = 6
  LEFT      = 7
  UPLOADED  = 8

  delegate :name, :email, to: :author, prefix: true, allow_nil: true
  delegate :title, to: :issue, prefix: true, allow_nil: true
  delegate :title, to: :comment, prefix: true, allow_nil: true

  belongs_to :author, class_name: "User"
  belongs_to :project
  belongs_to :target, polymorphic: true

  scope :recent, -> { order("created_at DESC") }
  scope :in_projects, ->(project_ids) { where(project_id: project_ids).recent }

  def closed?
    action == self.class::CLOSED
  end

  def reopened?
    action == self.class::REOPENED
  end

  def sprint?
    target_type == "Sprint"
  end

  def issue?
    target_type == "Issue"
  end

  def comment?
    target_type == "Comment"
  end

  def joined?
    action == JOINED
  end

  def left?
    action == LEFT
  end

  def uploaded?
    action == UPLOADED
  end

  def action_name
    if closed?
      "closed"
    elsif joined?
      'joined'
    elsif left?
      'left'
    elsif uploaded?
      'uploaded'
    else
      "opened"
    end
  end
end
