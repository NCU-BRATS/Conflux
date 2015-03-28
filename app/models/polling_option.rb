class PollingOption < ActiveRecord::Base
  acts_as_votable

  belongs_to :poll

  validates :title, presence: true

end
