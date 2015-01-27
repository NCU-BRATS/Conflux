class Issue < ActiveRecord::Base
  include AASM
  include ParserConcern
  include CommentableConcern
  include LabelableConcern

  sync :all

  belongs_to :project
  belongs_to :user
  belongs_to :sprint
  belongs_to :assignee, class_name: 'User'

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

  validates :title, :status, :project, :user, presence: true

  def to_param
    self.sequential_id.to_s
  end

  def self.commentable_find_key
    :sequential_id
  end

  def working?
    begin_at <= Time.now and Time.now <= due_at
  end

  def expired?
    Time.now > due_at and open?
  end

  def finished?
    Time.now > due_at and closed?
  end

  def planed?
    begin_at.present? and due_at.present?
  end

end
