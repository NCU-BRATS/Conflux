class AttachmentMentionService
  include Rails.application.routes.url_helpers

  def initialize
    @attachment_mention_filter = MentionFilters::AttachmentMentionFilter.new
  end

  def parse_mention(text, project)
    mentioned_attachments = []

    filtered_field = @attachment_mention_filter.filter(text) do |match, target|
      attachment_id = target.to_i
      attachment = Attachment.where(project: project, id: attachment_id).first
      mentioned_attachments << attachment if attachment
      link = link_to_mentioned_attachment(project, attachment)
      link ? match.sub("#{@attachment_mention_filter.mention_character}#{target}", link) : match
    end

    { filtered_content: filtered_field, mentioned_attachments: mentioned_attachments }
  end

  def link_to_mentioned_attachment(project, attachment)
    return nil unless attachment
    url = project_attachment_path(project, attachment)
    "<a href='#{url}' class='attachment-mention'>#{@attachment_mention_filter.mention_character}#{attachment.id}</a>"
  end

end
