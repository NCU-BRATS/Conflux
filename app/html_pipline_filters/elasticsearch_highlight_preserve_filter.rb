class ElasticsearchHighlightPreserveFilter < HTML::Pipeline::Filter

  def initialize(doc, context = nil, result = nil)
    html = doc.to_s
    html.gsub!(ProjectSearch::HIGHLIGHT_TAG, '<em>')
    html.gsub!(ProjectSearch::HIGHLIGHT_CLOSE_TAG, '</em>')
    super html, context, result
  end

  def call
    doc
  end

end
