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
    authorize @label
    respond_with @project, @label
  end

  def create
    @label = @project.labels.create(label_params)
    authorize @label
    respond_with @project, @label, location: project_labels_path(@project)
  end

  def edit
    authorize @label
  end

  def update
    authorize @label
    @label.update_attributes(label_params)
    respond_with @project, @label, location: project_labels_path(@project)
  end

  def destroy
    authorize @label
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
