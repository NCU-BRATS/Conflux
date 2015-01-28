class AttachmentPolicy < ApplicationPolicy

  def index?
    user.is_project_member?
  end

  def create?
    user.is_project_member?
  end

  def destroy?
    user.is_project_member?
  end

  def update?
    user.is_project_member?
  end

  def download?
    user.is_project_member?
  end

end
