class ProjectPolicy < ApplicationPolicy

  def update?
    record.is_memeber?(user)
  end

  def destroy?
    record.is_memeber?(user)
  end

end
