class Repository < ActiveRecord::Base

  validates :name, :link, presence: true

end
