class Notice < ActiveRecord::Base
  default_scope { where.not(author_id: nil) }

  enum action: [ :created, :updated, :closed, :reopened, :commented, :uploaded, :deleted, :mention ]
  enum state: [ :unseal, :seal ]
  enum mode: [ :unread, :read]

  belongs_to :owner, class_name: 'User'
  belongs_to :author, class_name: 'User'
  belongs_to :target, polymorphic: true
  belongs_to :project

  scope :recent, -> { order('created_at DESC') }

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

  def read!
    self.mode = :read
  end

  def seal!
    self.state = :seal
    self.mode = :read
  end

  def unseal!
    self.state = :unseal
  end

end
