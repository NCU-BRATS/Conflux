class Issue < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :sprint

  has_many :comments, as: :commentable

  has_many :issue_assigments
  has_many :assignees, through: :issue_assigments, source: :user

  validates :title, :serial, :status, :project, :user, :begin_at, :due_at, presence: true
end
