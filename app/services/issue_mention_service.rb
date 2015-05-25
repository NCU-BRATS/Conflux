class IssueMentionService
  include Rails.application.routes.url_helpers

  def mention_issue(field, mentionable)
    issue_mention_filter = MentionFilters::IssueMentionFilter.new

    mentioned_list = { 'issues' => [] }.merge(mentionable.mentioned_list || {})

    filtered_field = issue_mention_filter.filter(mentionable.send(field)) do |match, target|
      issue_id = target.to_i

      if !mentioned_list['issues'].include?(issue_id)
        mentioned_list['issues'] << issue_id
      end

      link = link_to_mentioned_issue(mentionable.project, target)
      link ? match.sub("##{target}", link) : match
    end

    mentionable.mentioned_list.merge!(mentioned_list)
    mentionable.send("#{field.to_s}=".to_sym, filtered_field)
  end

  def link_to_mentioned_issue(project, issue_id)
    url = project_issue_path(project, issue_id)
    "<a href='#{url}' class='user-mention'>##{issue_id}</a>"
  end

end
