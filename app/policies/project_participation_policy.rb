class ProjectParticipationPolicy < ApplicationPolicy

  def create?
    record.project.has_member?(user)
  end

  def destroy?
    record.project.has_member?(user)
  end

end
