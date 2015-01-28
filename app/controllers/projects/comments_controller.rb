class Projects::CommentsController < Projects::ApplicationController

  enable_sync only: [:create, :update, :destroy]

  def create
    @comment = commentable.comments.build comment_params
    @comment.user = current_user
    @comment.save
    respond_with @project, @comment
  end

  def update
    @comment.update_attributes(comment_params)
    respond_with @project, @comment
  end

  def destroy
    @comment.destroy
    respond_with @project, @comment
  end

  protected

  def commentable
    params.each do |name, value|
      if name=~ /(.+)_id$/
        return $1.classify.constantize.commentable_find( @project, value ).first if name != 'project_id'
      end
    end
    nil
  end

  def set_resourse
    @comment ||= Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit( :content )
  end

end
