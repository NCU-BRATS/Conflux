class DashboardPolicy < ApplicationPolicy

  def show?
    user.is_project_member?
  end

end
