module HTML
  class Pipeline
    class RougeSyntaxHighlightFilter < SyntaxHighlightFilter

      def highlight_with_timeout_handling(lexer, text)
        formatter = Rouge::Formatters::HTML.new
        formatter.format(lexer.lex(text))
      rescue Timeout::Error => boom
        nil
      end

      def lexer_for(lang)
        Rouge::Lexer.find(lang).new
      end

    end
  end
end
