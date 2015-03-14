class Projects::SettingsController < Projects::ApplicationController

  def determine_layout
    request.format.html? ? 'project_settings' : 'application'
  end

  def edit

  end

  def update
    @project.update(project_params)
    respond_with @project, location: edit_project_settings_path(@project)
  end

  def model
    :project_setting
  end

  def model_sym
    :project
  end

  protected

  def project_params
    params.require(:project).permit(:name, :description, :visibility_level)
  end

end
