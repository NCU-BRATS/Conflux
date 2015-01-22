class DashboardPolicy < ApplicationPolicy

  def show?
    record.has_member?(user)
  end

  def issues?
    record.has_member?(user)
  end

  def projects?
    record.has_member?(user)
  end

  def attachments?
    record.has_member?(user)
  end

end
