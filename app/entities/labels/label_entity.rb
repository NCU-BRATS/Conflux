module Labels
  class LabelEntity < Grape::Entity
    expose :id
    expose :title
    expose :color
  end
end
