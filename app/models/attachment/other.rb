class Attachment::Other < Attachment
  include SyncableConcern

  validates :path, :original_filename, presence: true

end
