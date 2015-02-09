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
    if user.respond_to?(:is_project_member?)
      user.is_project_member?
    else
      record.project.has_member?(user)
    end
  end

end
