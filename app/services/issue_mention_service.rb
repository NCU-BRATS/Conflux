class IssueMentionService
  include Rails.application.routes.url_helpers

  def parse_mention(text, project)
    issue_mention_filter = MentionFilters::IssueMentionFilter.new

    mentioned_issues = []

    filtered_field = issue_mention_filter.filter(text) do |match, target|
      issue_id = target.to_i
      issue = Issue.find(issue_id)
      mentioned_issues << issue if issue
      link = link_to_mentioned_issue(project, issue)
      link ? match.sub("##{target}", link) : match
    end

    { filterd_content: filtered_field, mentioned_issues: mentioned_issues }
  end

  def link_to_mentioned_issue(project, issue)
    return nil unless issue
    url = project_issue_path(project, issue)
    "<a href='#{url}' class='issue-mention'>##{issue.id}</a>"
  end

end
