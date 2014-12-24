class RougeSyntaxHighlightFilter < HTML::Pipeline::Filter

  def call
    doc.search('pre').each do |node|
      default = context[:highlight] && context[:highlight].to_s
      next unless ( lang = node['lang'] || default ).present?
      next unless ( lexer = lexer_for(lang) ).present?
      text = node.inner_text

      html = highlight_with_timeout_handling(lexer, text)
      next if html.nil?

      if ( node = node.replace(html).first ).present?
        klass = node['class']
        klass = [klass, "highlight-#{lang}"].compact.join ' '

        node['class'] = klass
      end
    end
    doc
  end

  def highlight_with_timeout_handling(lexer, text)
    formatter = Rouge::Formatters::HTML.new
    formatter.format(lexer.lex(text))
  rescue Timeout::Error => _
    nil
  end

  def lexer_for(lang)
    Rouge::Lexer.find(lang).new
  end

end
