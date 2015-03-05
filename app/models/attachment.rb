class Attachment < ActiveRecord::Base
  include CommentableConcern
  include ParticipableConcern
  include EventableConcern
  extend Enumerize

  belongs_to :project
  belongs_to :user

  mount_uploader :path, AttachmentUploader

  participate_by [:user]

  update_index('projects#attachment') { self if should_reindex? }

  validates :type, :project_id, :user_id, :project, :user, presence: true

  scope :latest, -> { order(created_at: :desc) }

  def self.policy_class
    AttachmentPolicy
  end

  def self.intelligent_construct(params, project, user)
    attachment = OtherAttachment.new(params.merge(project: project, user: user))

    return attachment if attachment.path.url.nil?

    content_type = attachment.path.file.content_type

    if content_type.start_with?('image')
      attachment = attachment.deep_becomes!(Image)
    elsif Snippet::LANGUAGES.include?(content_type.to_sym)
      attachment = attachment.deep_becomes!(Snippet)
      attachment.language = content_type
      attachment.content = attachment.path.read
    end

    if attachment.name.blank?
      attachment.name = attachment.path.file.filename
    end

    attachment.original_filename = attachment.path.file.filename

    attachment
  end

  def deep_becomes!(klass)
    became = becomes!(klass)
    became.path = self.path
    became
  end

  def download_filename
    original_filename || "#{name}.#{path.file.extension}"
  end

  def download_data
    path.url || content
  end

  def should_reindex?
    destroyed? || (previous_changes.keys & ['name', 'content', 'type', 'language']).present?
  end

end
