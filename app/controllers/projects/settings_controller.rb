class Projects::SettingsController < Projects::ApplicationController

  def determine_layout
    request.format.html? ? 'project_settings' : 'application'
  end

  def edit
    @form = Project::Update.new(current_user, @project)
  end

  def update
    @form = Project::Update.new(current_user, @project)
    @form.process(params)
    respond_with @form do |formats|
      formats.html { render('edit') }
    end
  end

  def destroy
    @form = Project::Destroy.new(current_user, @project)
    @form.process
    respond_with @form, location: dashboard_path
  end

  def model
    :project_setting
  end

  def model_sym
    :project
  end

end
