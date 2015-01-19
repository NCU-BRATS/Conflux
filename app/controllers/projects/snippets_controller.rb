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
    flash[:notice] = "已成功創建#{Attachment::Post.model_name.human}" if @snippet.save
    respond_with @project, @snippet
  end

  def show
    @snippet = @project.snippets.find(params[:id])
    respond_with @project, @snippet
  end

  def edit
    @snippet = @project.snippets.find(params[:id])
    respond_with @project, @snippet
  end

  def update
    @snippet = @project.snippets.find(params[:id])
    authorize @snippet
    flash[:notice] = "已成功修改#{Attachment.model_name.human}" if @snippet.update(snippet_params)
    respond_with @project, @snippet
  end

  protected
    def snippet_params
      params.require(:attachment_snippet).permit(:name, :language, :content)
    end

end
