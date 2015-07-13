class IssueMentionService
  include Rails.application.routes.url_helpers

  def initialize
    @issue_mention_filter = MentionFilters::IssueMentionFilter.new
  end

  def parse_mention(text, project)
    mentioned_issues = []

    filtered_field = @issue_mention_filter.filter(text) do |match, target|
      issue_id = target.to_i
      issue = Issue.where(project: project, sequential_id: issue_id).first
      mentioned_issues << issue if issue
      link = link_to_mentioned_issue(project, issue)
      link ? match.sub("#{@issue_mention_filter.mention_character}#{target}", link) : match
    end

    { filtered_content: filtered_field, mentioned_issues: mentioned_issues }
  end

  def link_to_mentioned_issue(project, issue)
    return nil unless issue
    url = project_issue_path(project, issue)
    "<a href='#{url}' class='issue-mention'>#{@issue_mention_filter.mention_character}#{issue.sequential_id}</a>"
  end

end
