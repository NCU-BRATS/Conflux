class PollMentionService
  include Rails.application.routes.url_helpers

  def initialize
    @attachment_mention_filter = MentionFilters::PollMentionFilter.new
  end

  def parse_mention(text, project)
    mentioned_polls = []

    filtered_field = @attachment_mention_filter.filter(text) do |match, target|
      poll_id = target.to_i
      poll = Poll.where(project: project, sequential_id: poll_id).first
      mentioned_polls << poll if poll
      link = link_to_mentioned_poll(project, poll)
      link ? match.sub("#{@attachment_mention_filter.mention_character}#{target}", link) : match
    end

    { filtered_content: filtered_field, mentioned_polls: mentioned_polls }
  end

  def link_to_mentioned_poll(project, poll)
    return nil unless poll
    url = project_poll_path(project, poll)
    "<a href='#{url}' class='poll-mention'>#{@attachment_mention_filter.mention_character}#{poll.sequential_id}</a>"
  end

end
