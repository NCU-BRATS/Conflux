class Projects::ApplicationController < ApplicationController
  layout :determine_layout

  before_action :set_project

  def determine_layout
    'application'
  end

  protected
  def set_project
    @project = Project.friendly.find(params[:project_id])
  end

end