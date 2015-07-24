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
        end
      end if validate(attachment_params(params))

      unless errors.valid?
        raise ::Grape::Exceptions::Base.new(message: 'validation failed', status: 400)
      end
    end

  end
end
