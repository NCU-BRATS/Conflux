class OtherAttachment < Attachment
  include SyncableConcern

  counter_culture :project

  validates :path, :original_filename, :size, presence: true

end
