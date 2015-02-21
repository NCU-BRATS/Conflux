module ParticipableConcern
  extend ActiveSupport::Concern

  included do
    has_many :participations, as: :participable
  end

  class_methods do
    def participate_by(columns, &block)
      after_save do |instance|
        participable = block ? yield(instance) : instance
        columns.each do |column|
          next unless instance.changes.has_key?("#{column.to_s}_id") &&
                      !participable.participations.exists?(user_id: instance.send(column))

          participable.participations.create(user: instance.send(column))
        end
      end
    end
  end
end
