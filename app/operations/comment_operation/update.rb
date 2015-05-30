module CommentOperation
  class Update < BaseForm

    def initialize(current_user, comment)
      @current_user = current_user
      super(comment)
    end

    def process(params)
      if validate(params[:comment]) && sync
        if @model.save
          create_mentioned_participation
          BroadcastService.fire(:on_comment_updated, @model, @model.previous_changes[:mentioned_list], @current_user)
        end
      end
    end


    private

    def create_mentioned_participation
      old_mentioned_list = @model.previous_changes[:mentioned_list][0] # mentioned_list before model saved
      new_mentioned_list = @model.previous_changes[:mentioned_list][1] # mentioned_list after model saved
      new_mentioned_list.each do |key, value|
        new_mentioned = value - old_mentioned_list[key]
        if key == 'members'
          User.find(new_mentioned).each do |mentioned_member|
            ParticipationOperation::Create.new(mentioned_member, @model.commentable).process
          end
        end
      end
    end

  end
end
