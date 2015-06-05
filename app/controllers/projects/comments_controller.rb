class Projects::CommentsController < Projects::ApplicationController

  def create
    @form = CommentOperation::Create.new(current_user, commentable)
    @form.process(params)
    PrivatePub.publish_to( private_pub_channel, {
         action: 'create',
         target: 'comment',
         data:   private_pub_data
     })
    respond_with @project, @form
  end

  def update
    @form = CommentOperation::Update.new(current_user, @comment)
    @form.process(params)
    PrivatePub.publish_to( private_pub_channel, {
        action: 'update',
        target: 'comment',
        data:   private_pub_data
    })
    respond_with @project, @form
  end

  def destroy
    @form = CommentOperation::Destroy.new(current_user, @comment)
    @form.process
    PrivatePub.publish_to( private_pub_channel, {
        action: 'destroy',
        target: 'comment',
        data:   private_pub_data
    })
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

  def private_pub_channel
    @private_pub_channel ||= "/#{@form.model.commentable_type.downcase}/#{@form.model.commentable_id}/comments"
  end

  def private_pub_data
    @form.model.as_json(include: :user)
  end

end
