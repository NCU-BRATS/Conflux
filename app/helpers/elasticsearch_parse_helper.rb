module ElasticsearchParseHelper

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

end
