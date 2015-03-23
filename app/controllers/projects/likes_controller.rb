class Projects::LikesController < Projects::ApplicationController
  enable_sync only: :update

  def update
    if resource.is_liked_by?(current_user)
      resource.delete_evaluation!(:likes, current_user)
    else
      resource.add_evaluation(:likes, 1, current_user)
    end
    resource.save
    respond_with(resource)
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

end