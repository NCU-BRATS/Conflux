module CommentableConcern
  extend ActiveSupport::Concern
  included do
    has_many :comments, as: :commentable
  end
end
