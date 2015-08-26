module ChannelOperation
  class Create < BaseForm

    def initialize(current_user, project)
      @current_user = current_user
      @project      = project
      super(Channel.new)
    end

    def process(params)
      if validate( channel_params(params) ) && sync
        @model.project = @project
        @model.members << @current_user
        @model.order = calculateNewOrder
        if @model.save
          BroadcastService.fire(:on_channel_created, @model, @current_user)
        end
      end
    end

    private

    def calculateNewOrder
      if @project.channels.count > 0
        @project.channels.maximum('order') + 99
      else
        0
      end
    end

  end
end
