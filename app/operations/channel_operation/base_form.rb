module ChannelOperation
  class BaseForm < Reform::Form
    model :channel

    property :name, validates: {presence: true}
    property :description
    property :announcement

    private

  end
end
