class WelcomeController < ApplicationController
  def index
    context = {
      :asset_root => "http://your-domain.com/where/your/images/live/icons",
      :base_url   => "http://your-domain.com"
    }
    markdown_pipeline = HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::SanitizationFilter,
      # HTML::Pipeline::CamoFilter,
      HTML::Pipeline::ImageMaxWidthFilter,
      HTML::Pipeline::HttpsFilter,
      HTML::Pipeline::MentionFilter,
      HTML::Pipeline::EmojiFilter,
      # HTML::Pipeline::SyntaxHighlightFilter
    ], context.merge(:gfm => true) # enable github formatted markdown

    filename = "#{Rails.root}/readme.md"
    @contents = File.read(filename)
    @text = markdown_pipeline.call(@contents)[:output]
  end
end
