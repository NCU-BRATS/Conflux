module CommentableConcern
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable
  end

  class_methods do

    def commentable_find( project, search_value )
      where( project_id: project.id, commentable_find_key => search_value )
    end

    def commentable_find_key
      :id
    end

  end

end
