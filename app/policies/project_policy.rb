class ProjectPolicy < ApplicationPolicy

  def update?
    record.has_member?(user)
  end

  def destroy?
    record.has_member?(user)
  end

end
