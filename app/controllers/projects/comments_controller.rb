class Projects::CommentsController < Projects::ApplicationController

  def create
    @form = CommentOperation::Create.new(current_user, commentable)
    @form.process(params)
    publish_to 'create'
    respond_with @project, @form
  end

  def update
    @form = CommentOperation::Update.new(current_user, @comment)
    @form.process(params)
    publish_to 'update'
    respond_with @project, @form
  end

  def destroy
    # @form = CommentOperation::Destroy.new(current_user, @comment)
    # @form.process
    # publish_to 'destroy'
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

  def publish_to( action )
    PrivatePub.publish_to( private_pub_channel1, {
         action: action,
         target: 'comment',
         data:   private_pub_data
     })
  end

  def private_pub_channel1
    if @form.model.commentable_type == 'Issue'
      @private_pub_channel1 ||= "/projects/#{@project.id}/issues/comments"
    else
      @private_pub_channel1 ||= "/#{@form.model.commentable_type.downcase}/#{@form.model.commentable_id}/comments"
    end
  end

  def private_pub_data
    @form.model.as_json(include: :user)
  end

end
