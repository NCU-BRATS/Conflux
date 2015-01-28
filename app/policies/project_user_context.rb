class ProjectUserContext

  attr_reader :user, :project

  def initialize( user, project )
    @user = user
    @project = project
  end

  def is_project_member?
    @project.has_member?(@user)
  end

end