class SuggestionPolicy < ProjectResourcePolicy

  def suggestions?
    is_user_project_member?
  end

end
