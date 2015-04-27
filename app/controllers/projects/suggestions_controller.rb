class Projects::SuggestionsController < Projects::ApplicationController

  def suggestions
    @issues = @project.issues
    @members = @project.members
  end

  def model
    :suggestions
  end
  
end
