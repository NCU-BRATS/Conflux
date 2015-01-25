class Attachment::Image < Attachment

  validates :path, presence: true

  def self.policy_class
    AttachmentPolicy
  end

end
