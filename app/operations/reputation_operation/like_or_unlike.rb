module ReputationOperation
  class LikeOrUnlike

    def initialize(current_user, resource)
      @current_user = current_user
      @resource     = resource
    end

    def process
      if @resource.is_liked_by?(@current_user)
        @resource.delete_evaluation!(:likes, @current_user)
        @resource.liked_users.reject! {|u| u['id'] == @current_user.id}
      else
        @resource.add_evaluation(:likes, 1, @current_user)
        @resource.liked_users << @current_user
      end
      @resource.save
    end

  end
end
