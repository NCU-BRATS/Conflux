class Projects::SnippetsController < Projects::ApplicationController

  def new
    @snippet = @project.snippets.build
    respond_with @project, @snippet
  end

  def create
    @snippet = @project.snippets.build(snippet_params)
    @snippet.user = current_user
    @snippet.save
    respond_with @project, @snippet
  end

  def show
    respond_with @project, @snippet
  end

  def edit
    respond_with @project, @snippet
  end

  def update
    @snippet.update(snippet_params)
    respond_with @project, @snippet
  end

  protected

  def snippet_params
    params.require(:attachment_snippet).permit(:name, :language, :content)
  end

  def resource
    @snippet ||= @project.snippets.find(params[:id])
  end

end
