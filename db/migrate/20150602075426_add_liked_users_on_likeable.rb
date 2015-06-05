class AddLikedUsersOnLikeable < ActiveRecord::Migration
  def change
    add_column :comments, :liked_users, :jsonb, default: []
    add_column :attachments, :liked_users, :jsonb, default: []
    ReputationSystem::Evaluation.delete_all
    ReputationSystem::Reputation.delete_all
    ReputationSystem::ReputationMessage.delete_all
  end
end
