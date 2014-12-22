class Issue < ActiveRecord::Base
  include AASM
  include ParserConcern

  belongs_to :project
  belongs_to :user
  belongs_to :sprint

  has_many :comments, as: :commentable

  has_many :issue_assigments
  has_many :assignees, through: :issue_assigments, source: :user

  acts_as_sequenced scope: :project_id

  accepts_nested_attributes_for :comments
  accepts_nested_attributes_for :issue_assigments, allow_destroy: true

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

end
