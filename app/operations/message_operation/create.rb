module MessageOperation
  class Create < BaseForm

    def initialize(current_user, channel)
      @current_user = current_user
      @channel      = channel
      super(Message.new)
    end

    def process(params)
      if validate(message_params(params)) && sync
        @model.user        = @current_user
        @model.channel     = @channel
        @model.save
      end
    end

  end
end
