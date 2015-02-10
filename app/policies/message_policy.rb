class MessagePolicy < ProjectResourcePolicy

  def update?
    is_same_user
  end

  def destroy?
    is_same_user
  end

  protected

  def is_same_user
    if user.is_a?(ProjectUserContext)
      record.user_id == user.user.id
    else
      record.user_id == user.id
    end
  end

end
