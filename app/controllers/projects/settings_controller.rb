class Projects::SettingsController < Projects::ApplicationController

  def determine_layout
    request.format.html? ? 'project_settings' : 'application'
  end

  def edit
    form Project::Update, params.merge({model: @project})
  end

  def update
    respond Project::Update, params.merge({model: @project}) do |op, formats|
      formats.html { render('edit') }
    end
  end

  def destroy
    @project.destroy
    respond_with @project, location: dashboard_path
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

  def interpolation_options
    { resource_name: @project.name }
  end

end
