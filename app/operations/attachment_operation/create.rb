module AttachmentOperation
  class Create < BaseForm

    def initialize(current_user, project)
      @current_user = current_user
      @project      = project
      super(Attachment.new)
    end

    def process(params)
      save do |hash|
        @model = Attachment::intelligent_construct(hash, @project, @current_user)

        if @model.save
          ParticipationOperation::Create.new(@current_user, @model).process
          BroadcastService.fire(:on_attachment_created, @model, @current_user)
          notice_service.upload_attachment(@model, @current_user)
        end
      end if validate(params[:attachment])
    end

  end
end
