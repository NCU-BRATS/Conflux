class Issue < ActiveRecord::Base
  include CloseableConcern
  include ParserConcern
  include ParticipableConcern
  include CommentableConcern
  include LabelableConcern

  sync :all

  belongs_to :project
  belongs_to :user
  belongs_to :sprint
  belongs_to :assignee, class_name: 'User'

  acts_as_sequenced scope: :project_id

  accepts_nested_attributes_for :comments

  participate_at [:user, :assignee], [:after_save]

  validates :title, :status, :project, :user, presence: true

  def to_param
    self.sequential_id.to_s
  end

  def self.commentable_find_key
    :sequential_id
  end

end
