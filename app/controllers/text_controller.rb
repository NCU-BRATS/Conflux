class TextController < ApplicationController

  def preview
    @content = Comment.parse( params[:content] )
    @name = params[:name]
  end

end

