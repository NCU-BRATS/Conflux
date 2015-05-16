class Projects::SnippetsController < Projects::ApplicationController

  enable_sync only: [:create, :update]

  def new
    @form = Snippet::Create.new(current_user, @project)
    respond_with @form
  end

  def create
    @form = Snippet::Create.new(current_user, @project)
    @form.process(params)
    respond_with @project, @form
  end

  def show
    respond_with @project, @snippet
  end

  def edit
    @form = Snippet::Update.new(current_user, @project, @snippet)
    respond_with @project, @snippet
  end

  def update
    @form = Snippet::Update.new(current_user, @project, @snippet)
    @form.process(params)
    respond_with @project, @form
  end

  protected

  def resource
    @snippet ||= @project.snippets.find(params[:id])
  end

end
