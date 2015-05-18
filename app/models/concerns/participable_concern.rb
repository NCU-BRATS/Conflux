module ParticipableConcern
  extend ActiveSupport::Concern

  included do
    has_many :participations, as: :participable
  end

end
