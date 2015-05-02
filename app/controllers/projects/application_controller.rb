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
    @project ||= Project.friendly.find(params[:project_id])
  end

  def pundit_user
    ProjectUserContext.new( current_user, set_project )
  end

  def event_service
    EventCreateService.new
  end

  def notice_service
    NoticeCreateService.new
  end

  def mention_service
    MentionService.new
  end

end
