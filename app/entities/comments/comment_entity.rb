module Comments
  class CommentEntity < Grape::Entity
    expose :id
    expose :content
    expose :html
    expose :commentable_id
    expose :commentable_type
    expose :user, using: Users::UserEntity
    expose :created_at
    expose :updated_at
  end
end
