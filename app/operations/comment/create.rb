class Comment < ActiveRecord::Base
  class Create < BaseForm

    def initialize(current_user, commentable)
      @current_user = current_user
      @commentable  = commentable
      super(Comment.new)
    end

    def process(params)
      if validate(params[:comment]) && sync
        @model.user        = @current_user
        @model.commentable = @commentable
        if @model.save
          event_service.leave_comment(@model, @current_user)
          notice_service.leave_comment(@model, @current_user)
          mention_service.mention_filter(:html, @model)
        end
      end
    end

  end
end
