class Issue < ActiveRecord::Base
  include CloseableConcern
  include ParserConcern
  include ParticipableConcern
  include CommentableConcern
  include LabelableConcern
  include EventableConcern

  sync :all

  belongs_to :project
  belongs_to :user
  belongs_to :sprint
  belongs_to :assignee, class_name: 'User'

  update_index('projects#issue')  { self   if should_reindex? }
  update_index('projects#sprint') { sprint if sprint.present? && should_reindex? }

  acts_as_sequenced scope: :project_id

  accepts_nested_attributes_for :comments

  participate_by [:user, :assignee]

  validates :title, :status, :project, :user, presence: true

  def to_param
    self.sequential_id.to_s
  end

  def self.commentable_find_key
    :sequential_id
  end

  def should_reindex?
    destroyed? || (changes.keys & ['title', 'sprint_id', 'status', 'begin_at', 'due_at']).present?
  end

end
