class Projects::Settings::ChannelsController < Projects::SettingsController

  def index
    @private_pub_channel1 = "/projects/#{@project.id}/channels"
    respond_with @project
  end

end
