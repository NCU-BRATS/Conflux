module ChannelOperation
  class Read < Reform::Form
    model :channel_participation

    property :last_read_floor, validates: {presence: true}

    def initialize(current_user, channel)
      @current_user = current_user
      @channel      = channel
      participantion = ChannelParticipation.where(user_id: @current_user.id)
                                           .where(channel_id: @channel.id).first
      super(participantion || ChannelParticipation.new)
    end

    def process(params)
      @model.channel = @channel if @model.channel.nil?
      @model.user = @current_user if @model.user.nil?

      validate(params) && params[:last_read_floor].to_i > @model.last_read_floor && save
    end
  end
end
