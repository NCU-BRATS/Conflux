class Attachment::Image < Attachment

  validates :path, :original_filename, presence: true

end
