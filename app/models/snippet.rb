class Snippet < Attachment
  include ParserConcern
  include SyncableConcern

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
    temp = "```#{language.downcase}\n"
    temp << content.lines.first(10).join
    temp << '...' if content.lines.size > 10
    temp << "\n```"
    @preview_html = self.class.parse(temp)
  end

  def download_filename
    original_filename || "#{name}.#{LANGUAGES[language.to_sym]}"
  end

end
