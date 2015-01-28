class CommentPolicy < ApplicationPolicy

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
