class Comment < ActiveRecord::Base
  include ParserConcern
  include ParticipableConcern
  include EventableConcern
  include FavorableConcern

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  delegate :participations, to: :commentable
  delegate :project, to: :commentable
  alias owner user

  update_index('projects#issue')      { commentable if for_issue?      && should_reindex? }
  update_index('projects#sprint')     { commentable if for_sprint?     && should_reindex? }
  update_index('projects#attachment') { commentable if for_attachment? && should_reindex? }
  update_index('projects#poll')       { commentable if for_poll?       && should_reindex? }

  validates :content, :user, presence: true
  before_save :parse_content

  delegate :project, to: :commentable

  scope :asc, -> { order(:created_at) }

  has_reputation :likes, source: :user

  def parse_content
    self.html = self.class.parse content
    self.html, new_mentioned = MentionService.parse_mentioned(html, project)
    self.mentioned_list.merge!(new_mentioned) { |key, old, new| (old | new).sort }
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

  def for_poll?
    commentable_type == 'Poll'
  end

  def should_reindex?
    destroyed? || (previous_changes.keys & ['content']).present?
  end

end
