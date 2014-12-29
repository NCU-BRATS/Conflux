
module ParserConcern
  extend ActiveSupport::Concern

  included do

    def self.parse( text )

      context = {
          :asset_root => 'http://your-domain.com/where/your/images/live/icons',
          :base_url   => 'http://your-domain.com'
      }
      markdown_pipeline = HTML::Pipeline.new [
                                                 HTML::Pipeline::MarkdownFilter,
                                                 HTML::Pipeline::SanitizationFilter,
                                                 # HTML::Pipeline::CamoFilter,
                                                 HTML::Pipeline::ImageMaxWidthFilter,
                                                 HTML::Pipeline::HttpsFilter,
                                                 HTML::Pipeline::MentionFilter,
                                                 HTML::Pipeline::EmojiFilter,
                                                 RougeSyntaxHighlightFilter
                                             ], context.merge(:gfm => true) # enable github formatted markdown
      markdown_pipeline.call( text )[:output]
    end

  end

end