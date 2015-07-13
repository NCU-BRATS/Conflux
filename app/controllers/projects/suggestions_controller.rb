class Projects::SuggestionsController < Projects::ApplicationController

  def suggestions
    @issues = @project.issues
    @members = @project.members.where.not(id: current_user.id)
    @sprints = @project.sprints
    @polls = @project.polls
    @attachments = @project.attachments
  end

  def model
    :suggestion
  end

end
