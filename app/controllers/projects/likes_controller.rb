class Projects::LikesController < Projects::ApplicationController
  enable_sync only: :update

  def update
    @form = ReputationOperation::LikeOrUnlike.new(current_user, resource)
    @form.process
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
