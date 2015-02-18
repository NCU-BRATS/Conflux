class OtherAttachment < Attachment
  include SyncableConcern

  validates :path, :original_filename, :size, presence: true

end