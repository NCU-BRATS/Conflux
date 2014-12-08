class ProjectsController < ApplicationController
  respond_to :html, :json, :js

  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @q = Project.search(params[:q])
    @projects = @q.result.page(params[:page]).per(params[:per])
    respond_with @projects
  end

  def show
    respond_with @project
  end

  def new
    @project = Project.new
    respond_with @project
  end

  def edit
    authorize @project
    respond_with @project
  end

  def create
    @project = Project.new(project_params)
    @project.members << current_user
    flash[:notice] = "已成功創建#{Project.model_name.human}" if @project.save
    respond_with @project
  end

  def update
    authorize @project
    flash[:notice] = "已成功修改#{Project.model_name.human}" if @project.update(project_params)
    respond_with @project
  end

  def destroy
    authorize @project
    @project.destroy
    flash[:notice] = "已成功刪除#{Project.model_name.human}"
    respond_with @project
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.friendly.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:name, :description)
    end
end
