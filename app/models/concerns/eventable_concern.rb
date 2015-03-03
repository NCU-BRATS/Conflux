module EventableConcern
  extend ActiveSupport::Concern
  included do
    def to_target_json
      self.to_json
    end
  end
end