class Projects::LabelsController < Projects::ApplicationController
  before_filter :set_label, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!

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

  def set_label
    @label ||= @project.labels.find(params[:id])
  end
end
