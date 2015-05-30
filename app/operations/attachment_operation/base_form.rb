module AttachmentOperation
  class BaseForm < Reform::Form

    model :attachment

    property :name
    property :path
    property :path_cache

    validates :name, :path, presence: true

    private

  end
end
