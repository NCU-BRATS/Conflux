class PollingOptionPolicy < ProjectResourcePolicy

  def close?
    is_user_project_member?
  end

  def reopen?
    is_user_project_member?
  end

end
