class PollingOption < ActiveRecord::Base

  belongs_to :poll

  validates :title, presence: true

  update_index('projects#poll') { poll }

  def votes_total
    self.voted_users.size
  end

  def voted_by?(user)
    self.voted_users.any? {|u| u['id'] == user.id}
  end

  def voted_by(user)
    self.voted_users << user
  end

  def unvoted_by(user)
    self.voted_users.reject! {|u| u['id'] == user.id}
  end

end
