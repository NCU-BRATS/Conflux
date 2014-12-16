class WelcomeController < ApplicationController
  def index
    filename = "#{Rails.root}/readme.md"
    @contents = File.read(filename)
    @text = GitHub::Markdown.render_gfm(@contents).html_safe
    @contents = @contents.gsub("\n", "<br>").html_safe
  end
end
