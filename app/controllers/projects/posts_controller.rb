class Projects::PostsController < Projects::ApplicationController

  def new
    @form = PostOperation::Create.new(current_user, @project)
    respond_with @form
  end

  def create
    @form = PostOperation::Create.new(current_user, @project)
    @form.process(params)
    respond_with @project, @form
  end

  def show
    @private_pub_channel2 = "/attachment/#{@post.id}/comments"
    respond_with @project, @post
  end

  def edit
    @form = PostOperation::Update.new(current_user, @project, @post)
    respond_with @project, @post
  end

  def update
    @form = PostOperation::Update.new(current_user, @project, @post)
    @form.process(params)
    respond_with @project, @form
  end

  protected

  def resource
    @post ||= @project.posts.find(params[:id])
  end

end
