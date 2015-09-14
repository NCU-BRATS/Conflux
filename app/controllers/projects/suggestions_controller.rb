class Projects::SuggestionsController < Projects::ApplicationController

  def suggestions
    @issues = @project.issues
    @members = @project.members.where.not(id: current_user.id)
    @sprints = @project.sprints
    @polls = @project.polls
    @attachments = @project.attachments
    @channels = @project.channels
  end

  def messages
    @channel = @project.channels.where(sequential_id: params[:channel_id]).first
    @messages = @channel.messages.where('content LIKE ?', "#{params[:query]}%")
  end

  def model
    :suggestion
  end

end
