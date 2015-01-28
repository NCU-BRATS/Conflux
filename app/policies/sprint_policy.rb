class SprintPolicy < ProjectResourcePolicy

  def close?
    user.is_project_member?
  end

  def reopen?
    user.is_project_member?
  end

end
