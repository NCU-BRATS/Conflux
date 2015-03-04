class Comment < ActiveRecord::Base
  include ParserConcern
  include ParticipableConcern
  include EventableConcern

  sync :all

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  participate_by [:user] do |instance|
    instance.commentable
  end

  update_index('projects#issue')      { commentable if for_issue?      && should_reindex? }
  update_index('projects#sprint')     { commentable if for_sprint?     && should_reindex? }
  update_index('projects#attachment') { commentable if for_attachment? && should_reindex? }

  validates :content, :user, presence: true

  before_save :parse_content, if: :content_changed?

  delegate :project, to: :commentable

  scope :asc, -> { order(:created_at) }

  sync_scope :by_commentable, ->(commentable){ where( commentable_type: commentable.class.base_class.name, commentable_id: commentable.id ) }

  def parse_content
    self.html = self.class.parse content
  end

  def to_target_json
    self.to_json(:include => :commentable)
  end

  def for_issue?
    commentable_type == 'Issue'
  end

  def for_sprint?
    commentable_type == 'Sprint'
  end

  def for_attachment?
    commentable_type == 'Attachment'
  end

  def should_reindex?
    destroyed? || (changes.keys & ['content']).present?
  end

end
