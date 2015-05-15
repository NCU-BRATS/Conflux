class Channel < ActiveRecord::Base
  class Update < BaseForm

    def initialize(current_user, project, channel)
      @current_user = current_user
      @project      = project
      super(channel)
    end

    def process(params)
      validate(params[:channel]) && save
    end

  end
end
