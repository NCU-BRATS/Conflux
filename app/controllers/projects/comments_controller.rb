class Projects::CommentsController < Projects::ApplicationController
  enable_sync only: [:create, :update, :destroy]
  before_action :authenticate_user!
  before_action :set_comment, only: [ :destroy, :update ]

  def create
    @comment = commentable.comments.build comment_params
    authorize @comment
    @comment.user = current_user
    @comment.save
    respond_with @project, @comment
  end

  def update
    authorize @comment
    @comment.update_attributes(comment_params)
    respond_with @project, @comment
  end

  def destroy
    authorize @comment
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

    def set_comment
      @comment ||= Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit( :content )
    end
end
