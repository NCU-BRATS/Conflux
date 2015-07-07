module SnippetsHelper
  def get_different_lang(language)
    if Snippet::LANGUAGES.size <= 1
      nil
    else
      loop do
        another_lang = Snippet::LANGUAGES.to_a.sample(1)[0][0]
        if another_lang != language
          return another_lang
        end
      end
    end
  end
end
