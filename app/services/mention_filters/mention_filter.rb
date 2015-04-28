class MentionFilters::MentionFilter

  def pattern
    raise NotImplementedError
  end

  def mention_character
    raise NotImplementedError
  end

  def filter(doc, &block)
    @doc = Nokogiri::HTML::DocumentFragment.parse(doc)

    search_text_nodes(@doc).each do |node|
      content = node.to_html
      next unless content.include?(mention_character)
      html = parse_out_targets(content, &block)
      next if html == content
      node.replace(html)
    end

    @doc.to_html
  end

  def parse_out_targets(text)
    text.gsub pattern do |match|
      target = $1
      yield(match, target)
    end
  end

  private

  def search_text_nodes(doc)
    nodes = doc.xpath('.//text()')
    nodes.empty? ? doc.xpath('text()') : nodes
  end

end
