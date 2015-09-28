module MessageOperation
  class Create < BaseForm

    def initialize(current_user, channel)
      @current_user = current_user
      @channel      = channel
      super(Message.new)
    end

    def process(params)
      if validate(message_params(params)) && sync
        @channel.with_lock do
          @model.user = @current_user
          @model.channel = @channel

          floor = @channel.max_floor + 1

          @model.sequential_id = floor
          @channel.max_floor = floor
          @channel.save
          @model.save
        end
      end
    end

  end
end
