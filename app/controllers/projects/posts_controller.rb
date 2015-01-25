class Projects::PostsController < Projects::ApplicationController

  before_action :set_post, only: [ :show, :edit, :update ]

  def new
    @post = @project.posts.build
    authorize @post
    respond_with @post
  end

  def create
    @post = @project.posts.build(post_params)
    @post.user = current_user
    authorize @post, :create?
    @post.save
    respond_with @project, @post
  end

  def show
    respond_with @project, @post
  end

  def edit
    authorize @post
    respond_with @project, @post
  end

  def update
    authorize @post
    @post.update(post_params)
    respond_with @project, @post
  end

  protected

  def post_params
    params.require(:attachment_post).permit(:name, :content)
  end

  def set_post
    @post = @project.posts.find(params[:id])
  end

end
