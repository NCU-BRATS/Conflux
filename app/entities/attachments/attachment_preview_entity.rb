module Attachments
  class AttachmentPreviewEntity < Grape::Entity
    expose :id
    expose :sequential_id
    expose :name
    expose :content_preview, if: lambda { |instance, options| ['Post', 'Snippet'].include?(instance.type)  } do |attachment|
      attachment.preview_html
    end
    expose :type
    expose :path, if: lambda { |instance, options| ['Image', 'OtherAttachment'].include?(instance.type)  }
    expose :language, if:  lambda { |instance, options| ['Image', 'OtherAttachment'].include?(instance.type)  }
    expose :original_filename, if: lambda { |instance, options| ['Image', 'OtherAttachment'].include?(instance.type)  }
    expose :size, if: lambda { |instance, options| ['Image', 'OtherAttachment'].include?(instance.type)  }
    expose :user, using: Users::UserEntity
    expose :created_at
    expose :updated_at
  end
end
