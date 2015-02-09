class AttachmentPolicy < ProjectResourcePolicy

  def download?
    is_user_project_member?
  end

end
