class SprintMentionService
  include Rails.application.routes.url_helpers

  def initialize
    @sprint_mention_filter = MentionFilters::SprintMentionFilter.new
  end

  def parse_mention(text, project)
    mentioned_sprints = []

    filtered_field = @sprint_mention_filter.filter(text) do |match, target|
      sprint_id = target.to_i
      sprint = Sprint.where(project: project, sequential_id: sprint_id).first
      mentioned_sprints << sprint if sprint
      link = link_to_mentioned_sprint(project, sprint)
      link ? match.sub("#{@sprint_mention_filter.mention_character}#{target}", link) : match
    end

    { filtered_content: filtered_field, mentioned_sprints: mentioned_sprints }
  end

  def link_to_mentioned_sprint(project, sprint)
    return nil unless sprint
    url = project_sprint_path(project, sprint)
    "<a href='#{url}' class='sprint-mention'>#{@sprint_mention_filter.mention_character}#{sprint.sequential_id}</a>"
  end

end
