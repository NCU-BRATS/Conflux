class Comment < ActiveRecord::Base
  class Destroy < BaseForm

    def initialize(current_user, comment)
      @current_user = current_user
      super(comment)
    end

    def process
      if @model.destroy
        event_service.delete_comment(@model, @current_user)
        notice_service.delete_comment(@model, @current_user)
      end
    end

  end
end
