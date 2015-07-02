module ChannelOperation
  class Update < BaseForm

    def initialize(current_user, project, channel)
      @current_user = current_user
      @project      = project
      super(channel)
    end

    def process(params)
      validate( channel_params( params ) ) && save
    end

  end
end
