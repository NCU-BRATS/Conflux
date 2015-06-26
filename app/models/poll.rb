class Poll < ActiveRecord::Base
  include CloseableConcern
  include ParserConcern
  include ParticipableConcern
  include CommentableConcern
  include EventableConcern

  belongs_to :project
  belongs_to :user

  has_many :options, class_name: 'PollingOption', dependent: :destroy

  acts_as_sequenced scope: :project_id

  accepts_nested_attributes_for :options, allow_destroy: true

  validates :title, :status, :project, :user, :options, presence: true

  update_index('projects#poll') { self }

  def before_close
    most_votes   = self.options.max_by {|op| op.votes_total }
    self.results = self.options.select {|op| op.votes_total == most_votes.votes_total}
  end

  def before_reopen
    self.results = []
  end

  def to_param
    self.sequential_id.to_s
  end

  def self.commentable_find_key
    :sequential_id
  end
end
