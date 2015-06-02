module FavorableConcern

  def total_likes
    self.liked_users.size
  end

  def is_liked_by?(user)
    self.liked_users.any? {|u| u['id'] == user.id}
  end

end
