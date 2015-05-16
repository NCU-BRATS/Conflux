class Projects::PostsController < Projects::ApplicationController

  enable_sync only: [:create, :update]

  def new
    @form = Post::Create.new(current_user, @project)
    respond_with @form
  end

  def create
    @form = Post::Create.new(current_user, @project)
    @form.process(params)
    respond_with @project, @form
  end

  def show
    respond_with @project, @post
  end

  def edit
    @form = Post::Update.new(current_user, @project, @post)
    respond_with @project, @post
  end

  def update
    @form = Post::Update.new(current_user, @project, @post)
    @form.process(params)
    respond_with @project, @form
  end

  protected

  def resource
    @post ||= @project.posts.find(params[:id])
  end

end
