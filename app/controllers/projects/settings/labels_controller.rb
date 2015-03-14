class Projects::Settings::LabelsController < Projects::SettingsController

  def index
    @q = @project.labels.search(params[:q])
    @labels = @q.result.order_by_name.page(params[:page]).per(20)
    respond_with @project, :settings, @labels
  end

  def new
    @label = @project.labels.new
    respond_with @project, :settings, @label
  end

  def create
    @label = @project.labels.create(label_params)
    respond_with @project, :settings, @label, location: project_settings_labels_path
  end

  def edit
    respond_with @project, :settings, @label
  end

  def update
    @label.update_attributes(label_params)
    respond_with @project, :settings, @label, location: project_settings_labels_path
  end

  def destroy
    @label.destroy
    respond_with @project, :settings, @label
  end

  def model
    Label
  end

  def model_sym
    :label
  end

  protected

  def label_params
    params.require(:label).permit(:title, :color)
  end

  def resource
    @label ||= @project.labels.find(params[:id])
  end

end
