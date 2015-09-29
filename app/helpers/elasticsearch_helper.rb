module ElasticsearchHelper

  def els_highlight(text, language)
    temp = "```#{language.downcase}\n"
    temp << text
    temp << "\n```"
    markdown_pipeline = HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::SanitizationFilter,
      RougeSyntaxHighlightFilter,
      ElasticsearchHighlightPreserveFilter
    ], {:gfm => true} # enable github formatted markdown

    '<div class="markdown-body">' + markdown_pipeline.call( temp )[:output].to_s + '</div>'
  end

  def els_markdown(text)
    markdown_pipeline = HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::SanitizationFilter,
      ElasticsearchHighlightPreserveFilter
    ], {:gfm => true} # enable github formatted markdown

    '<div class="markdown-body">' + markdown_pipeline.call( text )[:output].to_s + '</div>'
  end

  def filter_name(agg, bucket, project)
    case agg
    when 'status'
      if bucket['key'] == 'open' || bucket['key'] == 'closed'
        t("search.#{agg}.#{bucket['key']}")
      else
        statuses = []
        sprints = project.sprints
        sprints.each do |sprint|
          status = sprint.statuses.find {|s| s['id'].to_s == bucket['key']}
          statuses << status['name'] if status && !statuses.include?(status['name'])
        end
        statuses.join(', ')
      end
    when 'sprint'
      sprints = project.sprints
      sprint = sprints.find {|s| s.id == bucket['key']}
      sprint.title if sprint
    when 'assignee', 'user'
      members = project.members
      member = members.find {|m| m.id == bucket['key']}
      member.name if member
    when 'label'
      bucket['key']
    when 'attachment_type'
      bucket['key'].constantize.model_name.human
    when 'channel'
      channel = project.channels.find { |c| c.id == bucket['key']}
      channel.name if channel
    end
  end

end
