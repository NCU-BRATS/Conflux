class Sprint < ActiveRecord::Base
  include AASM
  include ParserConcern
  include CommentableConcern
  sync :all

  belongs_to :project
  belongs_to :user

  has_many :issues

  acts_as_sequenced scope: :project_id

  accepts_nested_attributes_for :comments

  aasm :column => 'status' do

    state :open, :initial => true
    state :closed

    event :close do
      transitions :from => :open, :to => :closed
    end

    event :reopen do
      transitions :from => :closed, :to => :open
    end

  end

  def to_param
    self.sequential_id.to_s
  end

  def self.commentable_find_key
    :sequential_id
  end

  def working?
    return false if begin_at.blank? or due_at.blank?
    Time.now >= begin_at and due_at <= Time.now
  end

  def expired?
    return false if due_at.blank?
    Time.now > due_at and status.upcase == 'OPEN'
  end

  validates :title, :status, :project, :user, presence: true

end
