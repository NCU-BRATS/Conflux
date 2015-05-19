module CommentOperation
  class Destroy < BaseForm

    def initialize(current_user, comment)
      @current_user = current_user
      super(comment)
    end

    def process
      if @model.destroy
        BroadcastService.fire(:on_comment_deleted, @model.to_target_json, @current_user)
      end
    end

  end
end
