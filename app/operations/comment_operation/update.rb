module CommentOperation
  class Update < BaseForm

    def initialize(current_user, comment)
      @current_user = current_user
      super(comment)
    end

    def process(params)
      if validate( comment_params( params ) ) && sync
        if @model.save
          create_mentioned_participation
          BroadcastService.fire(:on_comment_updated, @model, @model.previous_changes[:mentioned_list], @current_user)
        end
      end
    end


    private

    def create_mentioned_participation
      old_list, new_list = @model.previous_changes[:mentioned_list]

      return if old_list.nil? || new_list.nil?

      new_mentioned = new_list.fetch('members', []) - old_list.fetch('members', [])
      User.find(new_mentioned).each do |member|
        ParticipationOperation::Create.new(member, @model.commentable).process
      end
    end

  end
end
