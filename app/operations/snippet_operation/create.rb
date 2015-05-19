module SnippetOperation
  class Create < BaseForm

    def initialize(current_user, project)
      @current_user = current_user
      @project      = project
      super(Snippet.new)
    end

    def process(params)
      if validate(params[:snippet]) && sync
        @model.project = @project
        @model.user    = @current_user
        if @model.save
          ParticipationOperation::Create.new(@current_user, @model).process
          BroadcastService.fire(:on_attachment_created, @model, @current_user)
          notice_service.upload_attachment(@model, @current_user)
        end
      end
    end

  end
end
