class WelcomeController < ApplicationController
  def index
    filename = "#{Rails.root}/README.md"
    @contents = File.read(filename)
    @text = Comment.parse(@contents)
  end
end
