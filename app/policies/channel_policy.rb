class ChannelPolicy < ProjectResourcePolicy
  def read?
    is_user_project_public? || is_user_project_member?
  end

  def read_status?
    is_user_project_public? || is_user_project_member?
  end
end
