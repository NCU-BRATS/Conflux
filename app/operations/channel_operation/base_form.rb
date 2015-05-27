module ChannelOperation
  class BaseForm < Reform::Form
    model :channel

    property :name, validates: {presence: true}
    property :description
    property :announcement

    private

    def mention_service
      MentionService.new
    end

  end
end
