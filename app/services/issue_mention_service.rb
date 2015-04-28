class IssueMentionService
  include Rails.application.routes.url_helpers

  def mention_issue(field, mentionable)
    issue_mention_filter = MentionFilters::IssueMentionFilter.new

    filtered_field = issue_mention_filter.filter(mentionable.send(field)) do |match, target|
      link = link_to_mentioned_issue(mentionable.project, target)
      link ? match.sub("##{target}", link) : match
    end

    mentionable.send("#{field.to_s}=".to_sym, filtered_field)
  end

  def link_to_mentioned_issue(project, issue_id)
    url = project_issue_path(project, issue_id)
    "<a href='#{url}' class='user-mention'>##{issue_id}</a>"
  end

end
