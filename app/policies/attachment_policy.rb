class AttachmentPolicy < ApplicationPolicy
  def create?
    record.project.is_memeber?(user)
  end

  def destroy?
    record.project.is_memeber?(user)
  end

  def update?
    record.project.is_memeber?(user)
  end
end
