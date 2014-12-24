class CommentPolicy < ApplicationPolicy

  def update?
    record.project.is_memeber?(user)
  end

  def destroy?
    record.project.is_memeber?(user)
  end

  def create?
    record.project.is_memeber?(user)
  end

end
