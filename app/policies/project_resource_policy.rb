class ProjectResourcePolicy < ApplicationPolicy

  def index?
    true
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

end
