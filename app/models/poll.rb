class Poll < ActiveRecord::Base
  include CloseableConcern
  include ParserConcern
  include ParticipableConcern
  include CommentableConcern
  include EventableConcern

  sync :all

  belongs_to :project
  belongs_to :user

  has_many :options, class_name: 'PollingOption', dependent: :destroy

  acts_as_sequenced scope: :project_id

  accepts_nested_attributes_for :comments
  accepts_nested_attributes_for :options, allow_destroy: true

  validates :title, :status, :project, :user, :options, presence: true

  def to_param
    self.sequential_id.to_s
  end

  def self.commentable_find_key
    :sequential_id
  end
end
