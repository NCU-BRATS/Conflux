class ProjectResourcePolicy < ApplicationPolicy

  def index?
    is_user_project_public? || is_user_project_member?
  end

  def show?
    is_user_project_public? || is_user_project_member?
  end

  def update?
    is_user_project_member?
  end

  def destroy?
    is_user_project_member?
  end

  def create?
    is_user_project_member?
  end

  protected

  def is_user_project_member?
    if user.is_a?(ProjectUserContext)
      user.is_project_member?
    else
      user.is_member?(record.project)
    end
  end

  def is_user_project_public?
    if user.is_a?(ProjectUserContext)
      user.project.visibility_level.public?
    else
      record.project.visibility_level.public?
    end
  end

end
