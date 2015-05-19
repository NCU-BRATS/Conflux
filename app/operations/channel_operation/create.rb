module ChannelOperation
  class Create < BaseForm

    def initialize(current_user, project)
      @current_user = current_user
      @project      = project
      super(Channel.new)
    end

    def process(params)
      if validate(params[:channel]) && sync
        @model.project = @project
        @model.members << @current_user
        if @model.save
          BroadcastService.fire(:on_channel_created, @model, @current_user)
        end
      end
    end

  end
end
