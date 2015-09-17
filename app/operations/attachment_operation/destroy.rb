module AttachmentOperation
  class Destroy < BaseForm

    def initialize(current_user, project, attachment)
      @current_user = current_user
      @project      = project
      super(attachment)
    end

    def process
      type = @model.class.name
      json = @model.to_target_json
      if @model.destroy
        BroadcastService.fire(:on_attachment_deleted, @project, type, json, @current_user)
      end
    end

  end
end
