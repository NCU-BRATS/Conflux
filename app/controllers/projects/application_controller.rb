class Projects::ApplicationController < ApplicationController

  layout :determine_layout

  before_action :authenticate_user!
  before_action :set_project
  before_action :authorize_resourse

  def determine_layout
    request.format.html? ? 'project' : 'application'
  end

  protected

  def set_project
    @project ||= Project.find_by_slug!(params[:project_id])
  end

  def pundit_user
    ProjectUserContext.new( current_user, set_project )
  end

end
