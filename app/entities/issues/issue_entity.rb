module Issues
  class IssueEntity < Grape::Entity
    expose :id
    expose :title
    expose :sequential_id
    expose :status
    expose :created_at
    expose :updated_at
    expose :begin_at
    expose :due_at
    expose :assignee, using: Users::UserEntity
    expose :user,     using: Users::UserEntity
    expose :sprint,   using: Sprints::SprintEntity
    expose :labels, using: Labels::LabelEntity do |issue|
      issue.labels
    end
  end
end
