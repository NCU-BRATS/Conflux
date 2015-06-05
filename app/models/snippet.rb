class Snippet < Attachment
  include ParserConcern

  LANGUAGES = {:'Text'=>'txt', :'C'=>'c', :'C#'=>'cpp', :'C++'=>'cpp', :'Clojure'=>'clj', :'CoffeeScript'=>'coffee', :'Common Lisp'=>'lisp',
               :'CSS'=>'css', :'Diff'=>'diff', :'Emacs Lisp'=>'el', :'Erlang'=>'erl', :'Haskell'=>'hs', :'HTML'=>'html', :'Java'=>'java', :'JavaScript'=>'js',
               :'Lua'=>'lua', :'Objective-C'=>'m', :'Perl'=>'pl', :'PHP'=>'php', :'Python'=>'py', :'Ruby'=>'rb', :'Scala'=>'scala',
               :'Scheme'=>'scm', :'Shell'=>'sh', :'SQL'=>'sql'}
  enumerize :language, in: LANGUAGES.keys

  counter_culture :project

  validates :content, :language, :name, presence: true

  def html
    @html ||= self.class.parse("```#{language.downcase}\n#{content}\n```")
  end

  def preview_html
    return @preview_html if @preview_html

    preview_content_lines = content[0..1000].lines
    preview_content = "```#{language.downcase}\n"
    preview_content << preview_content_lines.first(10).join
    preview_content << "\n```"

    @preview_html = self.class.parse(preview_content)

    if preview_content_lines.size > 10 or preview_content.length > 1000
      preview_html_decorate @preview_html, is_partial:true
    else
      preview_html_decorate @preview_html, is_partial:false
    end
  end

  def download_filename
    original_filename || "#{name}.#{LANGUAGES[language.to_sym]}"
  end

end
