module ParticipableConcern
  extend ActiveSupport::Concern

  included do
    has_many :participations, as: :participable
  end

  class_methods do
    def participate_at(columns, callbacks, &block)
      callbacks.each do |callback|
        send(callback) do |instance|
          columns.each do |column|
            participation = Participation.new
            participation.user = instance.send(column)

            participable = block ? yield(instance) : instance
            participation.participable = participable
            participation.save unless participable.participations.exists?(user_id: participation.user)
          end
        end if respond_to?(callback)
      end
    end
  end
end
