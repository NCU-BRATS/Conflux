class ProjectsController < ApplicationController

  before_action :authenticate_user!

  def index
    @q = Project.with_visibility_level(:public).search(params[:q])
    @projects = @q.result.page(params[:page]).per(params[:per])
    respond_with @projects
  end

  def new
    form Project::Create
  end

  def create
    respond Project::Create, params.merge({current_user: current_user})
  end

  protected

  # Use callbacks to share common setup or constraints between actions.
  def resource
    @project ||= Project.friendly.find(params[:id])
  end

  def interpolation_options
    { resource_name: @project.name }
  end

end
