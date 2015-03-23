module FavorableConcern
 
  def total_likes
    self.reputation_for(:likes)
  end

  def is_liked_by?(user)
    self.has_evaluation?(:likes, user)
  end
 
end