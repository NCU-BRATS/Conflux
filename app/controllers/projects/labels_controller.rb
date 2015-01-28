class Projects::LabelsController < Projects::ApplicationController

  def index
    @q = @project.labels.search(params[:q])
    @labels = @q.result.order_by_name.page(params[:page]).per(20)
    respond_with @project, @labels
  end

  def new
    @label = @project.labels.new
    respond_with @project, @label
  end

  def create
    @label = @project.labels.create(label_params)
    respond_with @project, @label, location: project_labels_path(@project)
  end

  def edit
    respond_with @project, @label
  end

  def update
    @label.update_attributes(label_params)
    respond_with @project, @label, location: project_labels_path(@project)
  end

  def destroy
    @label.destroy
    respond_with @project, @label
  end

  protected

  def label_params
    params.require(:label).permit(:title, :color)
  end

  def set_resourse
    @label ||= @project.labels.find(params[:id])
  end

end
