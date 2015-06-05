module ChannelOperation
  class BaseForm < Reform::Form
    extend ActiveModel::ModelValidations
    model :channel

    property :name, validates: {presence: true}
    property :description
    property :announcement

    copy_validations_from Channel

  end
end
