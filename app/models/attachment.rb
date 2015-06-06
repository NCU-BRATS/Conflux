class Attachment < ActiveRecord::Base
  include CommentableConcern
  include ParticipableConcern
  include EventableConcern
  include FavorableConcern
  extend Enumerize

  belongs_to :project
  belongs_to :user

  mount_uploader :path, AttachmentUploader

  update_index('projects#attachment') { self if should_reindex? }

  validates :type, :project, :user, presence: true

  scope :latest, -> { order(created_at: :desc) }

  has_reputation :likes, source: :user

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

  def should_reindex?
    destroyed? || (previous_changes.keys & %w(name content type language)).present?
  end

  def preview_html_decorate( preview_html, options={} )
    options = options.symbolize_keys
    if options[:is_partial]
      '<div class="preview-partial"><div class="preview-partial-overlay"></div>' + preview_html + '</div>'
    else
      '<div class="preview-all">' + preview_html + '</div>'
    end
  end

end
