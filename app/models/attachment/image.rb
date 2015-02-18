class Attachment::Image < Attachment
  include SyncableConcern

  validates :path, :original_filename, :size, presence: true

end
