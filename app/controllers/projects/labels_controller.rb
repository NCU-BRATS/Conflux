class Projects::LabelsController < Projects::ApplicationController
  before_filter :label, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!

  def index
    @labels = @project.labels.order_by_name.page(params[:page]).per(20)
    respond_with @project, @labels
  end

  def new
    @label = @project.labels.new
    respond_with @project, @label
  end

  def create
    @label = @project.labels.create(label_params)

    if @label.valid?
      redirect_to project_labels_path(@project)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @label.update_attributes(label_params)
      redirect_to project_labels_path(@project)
    else
      render 'edit'
    end
  end

  def destroy
    @label.destroy
    respond_with @project, @label
  end

  def label_params
    params.require(:label).permit(:title, :color)
  end

  def label
    @label = @project.labels.find(params[:id])
  end
end