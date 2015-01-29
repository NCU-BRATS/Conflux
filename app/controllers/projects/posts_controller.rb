class Projects::PostsController < Projects::ApplicationController

  def new
    @post = @project.posts.build
    respond_with @post
  end

  def create
    @post = @project.posts.build(post_params)
    @post.user = current_user
    @post.save
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

  protected

  def post_params
    params.require(:attachment_post).permit(:name, :content)
  end

  def resource
    @post ||= @project.posts.find(params[:id])
  end

end
