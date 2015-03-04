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

  def filter_name(agg, bucket, results)
    case agg
    when 'status'
      t("search.#{agg}.#{bucket['key']}")
    when 'label'
      bucket['key']
    when 'attachment_type'
      bucket['key'].constantize.model_name.human
    when 'channel'
      messages = results.map(&:_object)
      channel = messages.map(&:channel).find { |c| c.id == bucket['key']}
      channel.name
    end
  end

end
