class Projects::Settings::RolesController < Projects::SettingsController

  def index
    @q = @project.project_roles.search(params[:q])
    @roles = @q.result.page(params[:page]).per(params[:per])
    respond_with @roles
  end

  def new
    @role = @project.project_roles.build
    respond_with @role
  end

  def create
    @role = @project.project_roles.create(role_params)
    respond_with @role, location: project_settings_roles_path
  end

  def edit
    respond_with @project
  end

  def update
    @role.update_attributes(role_params)
    respond_with @project, location: project_settings_roles_path
  end

  def destroy
    @role.destroy
    respond_with @role, location: project_settings_roles_path
  end

  protected

  def role_params
    params.require(:project_role).permit(:name)
  end

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
