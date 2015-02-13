class Attachment::Image < Attachment
  include SyncableConcern

  validates :path, :original_filename, presence: true

end
