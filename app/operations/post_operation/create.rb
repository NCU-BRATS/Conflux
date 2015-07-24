module PostOperation
  class Create < BaseForm

    def initialize(current_user, project)
      @current_user = current_user
      @project      = project
      super(Post.new)
    end

    def process(params)
      if validate(post_params(params)) && sync
        @model.project = @project
        @model.user    = @current_user
        if @model.save
          ParticipationOperation::Create.new(@current_user, @model).process
          BroadcastService.fire(:on_attachment_created, @model, @current_user)
        end
      end

      unless errors.valid?
        raise ::Grape::Exceptions::Base.new(message: 'validation failed', status: 400)
      end
    end

  end
end
