module ChannelOperation
  class Destroy < BaseForm

    def initialize(current_user, project, channel)
      @current_user = current_user
      @project      = project
      super(channel)
    end

    def process
      if @model.destroy
        BroadcastService.fire(:on_channel_deleted, @model, @current_user)
      end
    end

  end
end
