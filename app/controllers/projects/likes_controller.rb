class Projects::LikesController < Projects::ApplicationController

  def update
    @form = ReputationOperation::LikeOrUnlike.new(current_user, resource)
    @form.process
    private_pub_decide
    PrivatePub.publish_to( @private_pub_channel, {
        action: @private_pub_action,
        target: @private_pub_target,
        data:   @private_pub_data
    })
    head :ok
  end

  protected

  def resource
    @favor ||= favorable_find
  end

  def model
    :like
  end

  def favorable_find
    params.each do |name, value|
      if name=~ /(.+)_id$/
        return $1.classify.constantize.find(value) if name != 'project_id'
      end
      nil
    end
  end

  def private_pub_decide
    case @favor
    when Comment
      case @favor.commentable_type
      when 'Issue'
        @private_pub_channel = "/projects/#{@project.id}/issues/comments"
      else
        @private_pub_channel = "/#{@favor.commentable_type.downcase}/#{@favor.commentable_id}/comments"
      end
      @private_pub_action  = 'update'
      @private_pub_target  = 'comment'
      @private_pub_data    = @favor.as_json(include: :user)
    else
      nil
    end
  end

end
