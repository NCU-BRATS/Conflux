class Projects::SnippetsController < Projects::ApplicationController

  def new
    @snippet = @project.snippets.build
    authorize @snippet
    respond_with @project, @snippet
  end

  def create
    @snippet = @project.snippets.build(snippet_params)
    @snippet.user = current_user
    authorize @snippet
    @snippet.save
    respond_with @project, @snippet
  end

  def show
    @snippet = @project.snippets.find(params[:id])
    respond_with @project, @snippet
  end

  def edit
    authorize @snippet
    @snippet = @project.snippets.find(params[:id])
    respond_with @project, @snippet
  end

  def update
    @snippet = @project.snippets.find(params[:id])
    authorize @snippet
    @snippet.update(snippet_params)
    respond_with @project, @snippet
  end

  protected
    def snippet_params
      params.require(:attachment_snippet).permit(:name, :language, :content)
    end

end
