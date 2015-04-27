class StatisticPolicy < ProjectResourcePolicy

  def users?
    is_user_project_public? || is_user_project_member?
  end

  def tasks?
    is_user_project_public? || is_user_project_member?
  end

  def attachments?
    is_user_project_public? || is_user_project_member?
  end

end
