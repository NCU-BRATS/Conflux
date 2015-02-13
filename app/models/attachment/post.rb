class Attachment::Post < Attachment
  include ParserConcern
  include SyncableConcern

  validates :content, :name, presence: true

  def html
    @html ||= self.class.parse(content)
  end

  def preview_html
    return @preview_html if @preview_html
    temp = content.lines.first(10).join
    temp << '...' if content.lines.size > 10
    @preview_html = self.class.parse(temp)
  end

end
