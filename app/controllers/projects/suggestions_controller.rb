class Projects::SuggestionsController < Projects::ApplicationController

  def suggestions
    @issues = @project.issues
    @members = @project.members.where.not(id: current_user.id)
  end

  def model
    :suggestion
  end

end
