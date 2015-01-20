class Attachment < ActiveRecord::Base
  extend Enumerize

  belongs_to :project
  belongs_to :user

  mount_uploader :path, AttachmentUploader

  validates :type, :project_id, :user_id, :project, :user, presence: true

  def deep_becomes!(klass)
    became = becomes!(klass)
    became.path = self.path
    became
  end

  def self.intelligent_construct(params, project, user)
    attachment = Attachment::Other.new(params.merge(project: project, user: user))

    return attachment if attachment.path.url.nil?

    content_type = attachment.path.file.content_type

    if content_type.start_with?('image')
      attachment = attachment.deep_becomes!(Attachment::Image)
    elsif Attachment::Snippet::LANGUAGES.include?(content_type)
      attachment = attachment.deep_becomes!(Attachment::Snippet)
      attachment.language = content_type
      attachment.content = attachment.path.read
    end

    if attachment.name.blank?
      attachment.name = attachment.path.file.filename
    end

    attachment
  end

end
