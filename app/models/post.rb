class Post < Attachment
  include ParserConcern

  counter_culture :project

  validates :content, :name, presence: true

  def html
    @html ||= self.class.parse(content)
  end

  def preview_html
    return @preview_html if @preview_html

    preview_content_lines = content[0..1000].lines
    preview_content = preview_content_lines.first(10).join

    @preview_html = self.class.parse(preview_content)

    if preview_content_lines.size > 10 or preview_content.length > 1000
      preview_html_decorate @preview_html, is_partial:true
    else
      preview_html_decorate @preview_html, is_partial:false
    end
  end

  def download_filename
    "#{name}.md"
  end

end
