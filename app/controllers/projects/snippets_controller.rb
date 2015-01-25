class Projects::SnippetsController < Projects::ApplicationController

  before_action :set_snippet, only: [ :show, :edit, :update ]

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
    respond_with @project, @snippet
  end

  def edit
    authorize @snippet
    respond_with @project, @snippet
  end

  def update
    authorize @snippet
    @snippet.update(snippet_params)
    respond_with @project, @snippet
  end

  protected

  def snippet_params
    params.require(:attachment_snippet).permit(:name, :language, :content)
  end

  def set_snippet
    @snippet = @project.snippets.find(params[:id])
  end

end
