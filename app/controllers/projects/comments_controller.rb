class Projects::CommentsController < Projects::ApplicationController

  enable_sync only: [:create, :update, :destroy]

  def create
    @form = Comment::Create.new(current_user, commentable)
    @form.process(params)
    respond_with @project, @form
  end

  def update
    @form = Comment::Update.new(current_user, @comment)
    @form.process(params)
    respond_with @project, @form
  end

  def destroy
    @form = Comment::Destroy.new(current_user, @comment)
    @form.process
    respond_with @project, @form
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

  def resource
    @comment ||= Comment.find(params[:id])
  end

end
