class Participation < ActiveRecord::Base

  belongs_to :user
  belongs_to :participable, polymorphic: true

  validates :user, :participable, :subscribed, presence: true

  scope :subscribed,   -> { where(subscribed: true) }
  scope :unsubscribed, -> { where(subscribed: false) }

  def for_issue?
    participable_type == 'Issue'
  end

  def for_sprint?
    participable_type == 'Sprint'
  end

  def for_attachment?
    participable_type == 'Attachment'
  end

end
