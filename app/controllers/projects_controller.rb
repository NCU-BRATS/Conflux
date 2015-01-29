class ProjectsController < ApplicationController

  enable_sync only: [:create, :update, :destroy]

  before_action :authenticate_user!
  before_action :authorize_resourse, only: [:edit, :update, :destroy]

  def index
    @q = Project.search(params[:q])
    @projects = @q.result.page(params[:page]).per(params[:per])
    respond_with @projects
  end

  def new
    @project = Project.new
    respond_with @project
  end

  def edit
    respond_with @project
  end

  def create
    @project = Project.new(project_params)
    @project.members << current_user
    @project.save
    respond_with @project
  end

  def update
    @project.update(project_params)
    respond_with @project
  end

  def destroy
    @project.destroy
    respond_with @project
  end

  protected

  # Use callbacks to share common setup or constraints between actions.
  def resource
    @project ||= Project.friendly.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def project_params
    params.require(:project).permit(:name, :description)
  end

  def interpolation_options
    { resource_name: @project.name }
  end

end
