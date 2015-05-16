class Poll < ActiveRecord::Base
  class BaseForm < Reform::Form
    class << self
      extend Forwardable
      def_delegator :Poll, :reflect_on_association
    end

    include Composition

    model :poll

    property :title,                 on: :poll
    property :status,                on: :poll
    property :allow_multiple_choice, on: :poll
    collection :options,             on: :poll, populate_if_empty: PollingOption do
      property :id
      property :title
      property :_destroy, virtual: true
      validates :title, presence: true
    end

    validates :title, presence: true

    private

    def event_service
      EventCreateService.new
    end

    def notice_service
      NoticeCreateService.new
    end

    def mention_service
      MentionService.new
    end

  end
end
