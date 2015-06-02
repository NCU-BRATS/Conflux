class AddLikedUsersOnLikeable < ActiveRecord::Migration
  def change
    add_column :comments, :liked_users, :json, default: []
    add_column :attachments, :liked_users, :json, default: []
    ReputationSystem::Evaluation.delete_all
    ReputationSystem::Reputation.delete_all
    ReputationSystem::ReputationMessage.delete_all
  end
end
