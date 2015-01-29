class AttachmentPolicy < ProjectResourcePolicy

  def download?
    user.is_project_member?
  end

end
