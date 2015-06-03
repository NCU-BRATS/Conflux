class Projects::SnippetsController < Projects::ApplicationController

  enable_sync only: [:create, :update]

  def new
    @form = SnippetOperation::Create.new(current_user, @project)
    respond_with @form
  end

  def create
    @form = SnippetOperation::Create.new(current_user, @project)
    @form.process(params)
    respond_with @project, @form
  end

  def show
    @private_pub_channel2 = "/attachment/#{@snippet.id}/comments"
    respond_with @project, @snippet
  end

  def edit
    @form = SnippetOperation::Update.new(current_user, @project, @snippet)
    respond_with @project, @snippet
  end

  def update
    @form = SnippetOperation::Update.new(current_user, @project, @snippet)
    @form.process(params)
    respond_with @project, @form
  end

  protected

  def resource
    @snippet ||= @project.snippets.find(params[:id])
  end

end
