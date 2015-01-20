class Attachment::Snippet < Attachment
  include ParserConcern

  LANGUAGES = ["Text", "C", "C#", "C++", "Clojure", "CoffeeScript", "Common Lisp",
               "CSS", "Diff", "Emacs Lisp", "Erlang", "Haskell", "HTML", "Java", "JavaScript",
               "Lua", "Objective-C", "Perl", "PHP", "Python", "Ruby", "Scala",
               "Scheme", "Shell", "SQL"]
  enumerize :language, in: LANGUAGES

  validates :content, :language, :name, presence: true

  def self.policy_class
    AttachmentPolicy
  end

  def html
    @html ||= self.class.parse("```#{language.downcase}\n#{content}\n```")
  end

  def preview_html
    return @preview_html if @preview_html
    temp = "```#{language.downcase}\n"
    temp << content.lines.first(10).join
    temp << "..." if content.lines.size > 10
    temp << "\n```"
    @preview_html = self.class.parse(temp)
  end
end
