class Group < ActiveRecord::Base
  belongs_to :leader, class_name: 'User'

  has_many :group_participations
  has_many :users, through: :group_participations

  validates :leader, :name, presence: true
end
