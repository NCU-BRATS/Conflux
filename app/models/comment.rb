class Comment < ActiveRecord::Base
  include ParserConcern
  include ParticipableConcern
  include EventableConcern
  include FavorableConcern

  sync :all

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
  before_save :parse_mentioned

  delegate :project, to: :commentable

  scope :asc, -> { order(:created_at) }

  sync_scope :by_commentable, ->(commentable){ where( commentable_type: commentable.class.base_class.name, commentable_id: commentable.id ) }

  has_reputation :likes, source: :user

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

  def for_poll?
    commentable_type == 'Poll'
  end

  def should_reindex?
    destroyed? || (previous_changes.keys & ['content']).present?
  end


  private

  def parse_mentioned
    parse_content
    parse_mentioned_member
    parse_mentioned_issue
  end

  def parse_mentioned_member
    parse_result = MemberMentionService.new.parse_mention(html)
    self.html = parse_result[:filterd_content]
    mentioned_members = parse_result[:mentioned_members]
    self.mentioned_list.reverse_merge!({ 'members' => [] })
    self.mentioned_list['members'] += mentioned_members.map(&:id).as_json
    self.mentioned_list['members'] = self.mentioned_list['members'].sort.uniq
  end

  def parse_mentioned_issue
    parse_result = IssueMentionService.new.parse_mention(html, project)
    self.html = parse_result[:filterd_content]
    mentioned_issues = parse_result[:mentioned_issues]
    self.mentioned_list.reverse_merge!({ 'issues' => [] })
    self.mentioned_list['issues'] += mentioned_issues.map(&:id).as_json
    self.mentioned_list['issues'] = self.mentioned_list['issues'].sort.uniq
  end

end
