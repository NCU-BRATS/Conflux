class Projects::PostsController < Projects::ApplicationController

  def new
    @post = @project.posts.build
    authorize @post
    respond_with @post
  end

  def create
    @post = @project.posts.build(post_params)
    @post.user = current_user
    authorize @post, :create?
    flash[:notice] = "已成功創建#{Attachment::Post.model_name.human}" if @post.save
    respond_with @project, @post
  end

  def show
    @post = @project.posts.find(params[:id])
    respond_with @project, @post
  end

  def edit
    @post = @project.posts.find(params[:id])
    respond_with @project, @post
  end

  def update
    @post = @project.posts.find(params[:id])
    authorize @post
    flash[:notice] = "已成功修改#{Attachment::Post.model_name.human}" if @post.update(post_params)
    respond_with @project, @post
  end

  protected
    def post_params
      params.require(:attachment_post).permit(:name, :content)
    end

end
