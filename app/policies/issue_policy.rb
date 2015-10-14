class IssuePolicy < ProjectResourcePolicy

  def close?
    is_user_project_member?
  end

  def reopen?
    is_user_project_member?
  end

  def participations?
    is_user_project_public? || is_user_project_member?
  end

  def comments?
    is_user_project_public? || is_user_project_member?
  end

end
