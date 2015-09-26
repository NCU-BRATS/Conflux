class Projects::ArchivesController < Projects::ApplicationController

  def determine_layout
    request.format.html? ? 'project_settings' : 'application'
  end

  def index
    @private_pub_channel1 = "/projects/#{@project.id}/sprints"
    @private_pub_channel2 = "/projects/#{@project.id}/channels"
    respond_with @project
  end

  def model
    :archive
  end

end
