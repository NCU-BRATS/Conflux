class LabelPolicy < ApplicationPolicy

  def update?
    record.project.has_member?(user)
  end

  def destroy?
    record.project.has_member?(user)
  end

  def create?
    record.project.has_member?(user)
  end

end
