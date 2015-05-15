class Comment < ActiveRecord::Base
  class Update < BaseForm

    def initialize(current_user, comment)
      @current_user = current_user
      super(comment)
    end

    def process(params)
      validate(params[:comment]) && save
    end

  end
end
