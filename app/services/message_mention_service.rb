class MessageMentionService
  include Rails.application.routes.url_helpers

  def initialize
    @message_mention_filter = MentionFilters::MessageMentionFilter.new
  end

  def parse_mention(text, project)
    mentioned_messages = []

    filtered_field = @message_mention_filter.filter(text) do |match, target|
      match_data = /([1-9][0-9]*)-([1-9][0-9]*)/.match(target)
      channel_id = match_data[1]
      message_id = match_data[2]
      channel = project.channels.where(sequential_id: channel_id).first
      message = channel.messages.where(sequential_id: message_id).first
      mentioned_messages << message if message
      link = link_to_mentioned_message(project, message)
      link ? match.sub("#{@message_mention_filter.mention_character}#{target}", link) : match
    end

    { filtered_content: filtered_field, mentioned_messages: mentioned_messages }
  end

  def link_to_mentioned_message(project, message)
    return nil unless message
    url = project_channel_path(project, message.channel.slug) + "##{message.sequential_id}"
    "<a href='#{url}' class='message-mention'>#{@message_mention_filter.mention_character}#{message.channel.sequential_id}-#{message.sequential_id}</a>"
  end

end
