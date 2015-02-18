class Projects::PostsController < Projects::ApplicationController

  enable_sync only: [:create, :update]

  def new
    @post = @project.posts.build
    respond_with @post
  end

  def create
    @post = @project.posts.build(post_params)
    @post.user = current_user
    if @post.save
      event_service.upload_attachment(@post, current_user)
    end
    respond_with @project, @post
  end

  def show
    respond_with @project, @post
  end

  def edit
    respond_with @project, @post
  end

  def update
    @post.update(post_params)
    respond_with @project, @post
  end

  def model
    @model ||= Post
  end

  def model_sym
    :Post
  end

  protected

  def post_params
    params.require(:post).permit(:name, :content)
  end

  def resource
    @post ||= @project.posts.find(params[:id])
  end

end
