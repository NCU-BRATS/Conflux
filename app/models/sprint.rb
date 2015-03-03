class Sprint < ActiveRecord::Base
  include CloseableConcern
  include ParserConcern
  include ParticipableConcern
  include CommentableConcern
  include EventableConcern

  sync :all

  belongs_to :project
  belongs_to :user

  has_many :issues

  acts_as_sequenced scope: :project_id

  accepts_nested_attributes_for :comments

  participate_by [:user]

  validates :title, :status, :project, :user, presence: true

  def to_param
    self.sequential_id.to_s
  end

  def self.commentable_find_key
    :sequential_id
  end

end
