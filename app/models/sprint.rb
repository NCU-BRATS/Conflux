class Sprint < ActiveRecord::Base
  include ParserConcern
  include ParticipableConcern
  include CommentableConcern
  include EventableConcern
  include PlannableConcern

  belongs_to :project
  belongs_to :user

  has_many :issues

  acts_as_sequenced scope: :project_id

  update_index('projects#sprint') { self if should_reindex? }

  validates :title, :project, :user, presence: true

  def to_param
    self.sequential_id.to_s
  end

  def self.commentable_find_key
    :sequential_id
  end

  def should_reindex?
    destroyed? || (previous_changes.keys & %w(title status begin_at due_at)).present?
  end


end
