module AttachmentOperation
  class Destroy < BaseForm

    def initialize(current_user, project, attachment)
      @current_user = current_user
      @project      = project
      super(attachment)
    end

    def process
      if @model.destroy
        BroadcastService.fire(:on_attachment_deleted, @model, @current_user)
      end
    end

  end
end
