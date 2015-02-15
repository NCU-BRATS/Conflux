class ChannelParticipation < ActiveRecord::Base

  self.table_name = 'users_channels'

  belongs_to :user
  belongs_to :channel

  validates :user, presence: true
  validates :channel, presence: true
  validates :user, uniqueness: { scope: :channel }

end
