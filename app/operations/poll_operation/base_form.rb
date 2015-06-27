module PollOperation
  class BaseForm < Reform::Form
    class << self
      extend Forwardable
      def_delegator :Poll, :reflect_on_association
    end

    model :poll

    property :title
    property :status
    property :allow_multiple_choice
    collection :options, populate_if_empty: PollingOption do
      property :id
      property :title
      property :_destroy, virtual: true
      validates :title, presence: true
    end

    validates :title, presence: true

    def poll_params(params)
      params.require(:poll)
    end

  end
end
