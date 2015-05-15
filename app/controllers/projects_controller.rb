class ProjectsController < ApplicationController

  before_action :authenticate_user!

  def index
    @q = Project.with_visibility_level(:public).search(params[:q])
    @projects = @q.result.page(params[:page]).per(params[:per])
    respond_with @projects
  end

  def new
    @form = Project::Create.new(current_user)
    respond_with @form
  end

  def create
    @form = Project::Create.new(current_user)
    @form.process(params)
    respond_with @form, location: project_dashboard_path(@form)
  end

  protected

  # Use callbacks to share common setup or constraints between actions.
  def resource
    @project ||= Project.friendly.find(params[:id])
  end

  def interpolation_options
    { resource_name: @form.name }
  end

end
