class Participation < ActiveRecord::Base

  belongs_to :user
  belongs_to :participable, polymorphic: true

  validates :user, :participable, :subscribed, presence: true

end
