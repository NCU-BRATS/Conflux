module Projects
  class ProjectEntity < Grape::Entity
    expose :id
    expose :name
    expose :description
    expose :created_at
    expose :updated_at
    expose :slug
    expose :posts_count
    expose :snippets_count
    expose :images_count
    expose :other_attachments_count
    expose :visibility_level
  end
end
