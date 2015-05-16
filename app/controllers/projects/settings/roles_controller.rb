class Projects::Settings::RolesController < Projects::SettingsController

  def index
    @q = @project.project_roles.search(params[:q])
    @roles = @q.result.page(params[:page]).per(params[:per])
    respond_with @roles
  end

  def new
    @form = ProjectRole::Create.new(current_user, @project)
    respond_with @project, @form
  end

  def create
    @form = ProjectRole::Create.new(current_user, @project)
    @form.process(params)
    respond_with @project, @form, location: project_settings_roles_path
  end

  def edit
    @form = ProjectRole::Update.new(current_user, @project, @role)
    respond_with @project, @form
  end

  def update
    @form = ProjectRole::Update.new(current_user, @project, @role)
    @form.process(params)
    respond_with @project, @form, location: project_settings_roles_path
  end

  def destroy
    @form = ProjectRole::Destroy.new(current_user, @project, @role)
    @form.process
    respond_with @project, @form, location: project_settings_roles_path
  end

  protected

  def resource
    @role ||= @project.project_roles.find(params[:id])
  end

  def model
    ProjectRole
  end

  def model_sym
    :role
  end

end
