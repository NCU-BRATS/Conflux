class Attachment::Other < Attachment

  validates :path, :original_filename, presence: true

end
