class Post < Attachment
  include ParserConcern
  include SyncableConcern

  counter_culture :project

  validates :content, :name, presence: true

  def html
    @html ||= self.class.parse(content)
  end

  def preview_html
    return @preview_html if @preview_html
    temp = content.lines.first(10).join
    @preview_html = self.class.parse(temp)
    if content.lines.size > 10
      preview_html_decorate @preview_html, is_partial:true
    else
      preview_html_decorate @preview_html, is_partial:false
    end
  end

  def download_filename
    "#{name}.md"
  end

end
