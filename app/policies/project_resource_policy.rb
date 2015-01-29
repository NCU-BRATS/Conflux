class ProjectResourcePolicy < ApplicationPolicy

  def index?
    true
  end

  def update?
    user.is_project_member?
  end

  def destroy?
    user.is_project_member?
  end

  def create?
    user.is_project_member?
  end

end
