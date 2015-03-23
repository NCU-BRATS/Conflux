class AddEvaluationsIndex < ActiveRecord::Migration
  def self.up
    add_index :rs_evaluations, [:reputation_name, :source_id, :source_type, :target_id, :target_type], :name => "index_rs_evaluations_on_reputation_name_and_source_and_target"
  end

  def self.down
    remove_index :rs_evaluations, :name => "index_rs_evaluations_on_reputation_name_and_source_and_target"
  end
end
