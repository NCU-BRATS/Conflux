module ReputationOperation
  class LikeOrUnlike

    def initialize(current_user, resource)
      @current_user = current_user
      @resource     = resource
    end

    def process
      if @resource.is_liked_by?(@current_user)
        @resource.delete_evaluation!(:likes, @current_user)
      else
        @resource.add_evaluation(:likes, 1, @current_user)
      end
      @resource.save # trigger sync
    end

  end
end
