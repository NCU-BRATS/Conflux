class Attachment::Other < Attachment

  validates :path, :original_filename, presence: true

  def self.policy_class
    AttachmentPolicy
  end

end
