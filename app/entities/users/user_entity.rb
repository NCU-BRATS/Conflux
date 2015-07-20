module Users
  class UserEntity < Grape::Entity
    expose :id
    expose :name
    expose :email
    expose :created_at
    expose :updated_at
    expose :slug
    expose :phone
    expose :url
    expose :github
    expose :linkedin
    expose :facebook
    expose :twitter
  end
end
