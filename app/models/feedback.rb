class Feedback < ActiveRecord::Base
  belongs_to :user

  validates :user, :body, presence: true
end
