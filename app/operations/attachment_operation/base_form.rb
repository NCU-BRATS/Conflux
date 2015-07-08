module AttachmentOperation
  class BaseForm < Reform::Form

    model :attachment

    property :name
    property :path
    property :path_cache

    validates :name, :path, presence: true

    def attachment_params(params)
      params.require(:attachment)
    end

  end
end
