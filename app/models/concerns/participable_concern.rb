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
          participation = Participation.new
          participation.user = instance.send(column)
          participation.participable = participable
          participation.save
        end
      end
    end
  end
end
