module CommentOperation
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
          ParticipationOperation::Create.new(@current_user, @model.commentable).process
          User.find(@model.mentioned_list['members']).each do |mentioned_member|
            ParticipationOperation::Create.new(mentioned_member, @model.commentable).process
          end
          BroadcastService.fire(:on_comment_created, @model, @current_user)
        end
      end
    end

  end
end
