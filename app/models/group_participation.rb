class GroupParticipation < ActiveRecord::Base

  self.table_name = 'users_groups'

  belongs_to :user
  belongs_to :group

  validates :user, presence: true
  validates :group, presence: true
  validates :user, uniqueness: { scope: :group }

end
