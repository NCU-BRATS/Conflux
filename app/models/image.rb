class Image < Attachment

  counter_culture :project

  validates :path, :original_filename, :size, presence: true

end
