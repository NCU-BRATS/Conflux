class Sprint < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  has_many :issues
  has_many :comments, as: :commentable

  validates :title, :serial, :status, :project, :user, :begin_at, :due_at, presence: true
end
