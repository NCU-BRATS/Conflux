class Projects::Settings::LabelsController < Projects::SettingsController

  def index
    @q = @project.labels.search(params[:q])
    @labels = @q.result.order_by_name.page(params[:page]).per(20)
    respond_with @project, :settings, @labels
  end

  def new
    @form = Label::Create.new(current_user, @project)
    respond_with @project, :settings, @form
  end

  def create
    @form = Label::Create.new(current_user, @project)
    @form.process(params)
    respond_with @project, :settings, @form, location: project_settings_labels_path
  end

  def edit
    @form = Label::Update.new(current_user, @project, @label)
    respond_with @project, :settings, @form
  end

  def update
    @form = Label::Update.new(current_user, @project, @label)
    @form.process(params)
    respond_with @project, :settings, @form, location: project_settings_labels_path
  end

  def destroy
    @form = Label::Destroy.new(current_user, @project, @label)
    @form.process
    respond_with @project, :settings, @form
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
