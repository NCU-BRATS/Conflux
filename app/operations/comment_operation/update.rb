module CommentOperation
  class Update < BaseForm

    def initialize(current_user, comment)
      @current_user = current_user
      super(comment)
    end

    def process(params)
      if validate(params[:comment]) && sync
        mention_service.mention_filter(:html, @model)
        @model.save
      end
    end

  end
end
