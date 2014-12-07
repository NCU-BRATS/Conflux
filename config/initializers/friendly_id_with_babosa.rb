module FriendlyId
  module Slugged
    def normalize_friendly_id(value)
      value.to_slug.normalize.to_s
    end
  end
end
