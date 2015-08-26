class Projects::ArchivesController < Projects::ApplicationController

  def index
    @private_pub_channel1 = "/projects/#{@project.id}/sprints"
    respond_with @project
  end

  def model
    :archive
  end

end
