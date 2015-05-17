class Attachment < ActiveRecord::Base
  class Destroy < BaseForm

    def initialize(current_user, project, attachment)
      @current_user = current_user
      @project      = project
      super(attachment)
    end

    def process
      if @model.destroy
        event_service.delete_attachment(@model, @current_user)
      end
    end

  end
end
