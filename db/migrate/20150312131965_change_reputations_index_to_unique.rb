class ChangeReputationsIndexToUnique < ActiveRecord::Migration
  def self.up
    remove_index :rs_reputations, :name => "index_rs_reputations_on_reputation_name_and_target"
    add_index :rs_reputations, [:reputation_name, :target_id, :target_type], :name => "index_rs_reputations_on_reputation_name_and_target", :unique => true
  end

  def self.down
    remove_index :rs_reputations, :name => "index_rs_reputations_on_reputation_name_and_target"
    add_index :rs_reputations, [:reputation_name, :target_id, :target_type], :name => "index_rs_reputations_on_reputation_name_and_target"
  end
end
