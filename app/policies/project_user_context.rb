class ProjectUserContext

  attr_reader :user, :project

  def initialize( user, project )
    @user = user
    @project = project
  end

  def is_project_member?
    @user.is_member?(@project)
  end

end
