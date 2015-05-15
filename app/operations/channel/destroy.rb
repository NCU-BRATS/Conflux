class Channel < ActiveRecord::Base
  class Destroy < BaseForm

    def initialize(current_user, project, channel)
      @current_user = current_user
      @project      = project
      super(channel)
    end

    def process
      if @model.destroy
        event_service.delete_channel(@model, @current_user)
      end
    end

  end
end
