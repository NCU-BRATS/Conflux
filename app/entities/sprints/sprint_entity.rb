module Sprints
  class SprintEntity < Grape::Entity
    expose :id
    expose :title
    expose :sequential_id
    expose :status
    expose :created_at
    expose :updated_at
    expose :begin_at
    expose :due_at
    expose :user, using: Users::UserEntity
    expose :issues_count
  end
end
