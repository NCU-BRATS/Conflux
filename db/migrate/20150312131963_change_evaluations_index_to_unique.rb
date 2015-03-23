class ChangeEvaluationsIndexToUnique < ActiveRecord::Migration
  def self.up
    remove_index :rs_evaluations, :name => "index_rs_evaluations_on_reputation_name_and_source_and_target"
    add_index :rs_evaluations, [:reputation_name, :source_id, :source_type, :target_id, :target_type], :name => "index_rs_evaluations_on_reputation_name_and_source_and_target", :unique => true
  end

  def self.down
    remove_index :rs_evaluations, :name => "index_rs_evaluations_on_reputation_name_and_source_and_target"
    add_index :rs_evaluations, [:reputation_name, :source_id, :source_type, :target_id, :target_type], :name => "index_rs_evaluations_on_reputation_name_and_source_and_target"
  end
end
