class CreateReputationSystem < ActiveRecord::Migration
  def self.up
    create_table :rs_evaluations do |t|
      t.string      :reputation_name
      t.references  :source, :polymorphic => true
      t.references  :target, :polymorphic => true
      t.float       :value, :default => 0
      t.timestamps
    end

    add_index :rs_evaluations, :reputation_name
    add_index :rs_evaluations, [:target_id, :target_type]
    add_index :rs_evaluations, [:source_id, :source_type]

    create_table :rs_reputations do |t|
      t.string      :reputation_name
      t.float       :value, :default => 0
      t.string      :aggregated_by
      t.references  :target, :polymorphic => true
      t.boolean     :active, :default => true
      t.timestamps
    end

    add_index :rs_reputations, :reputation_name
    add_index :rs_reputations, [:target_id, :target_type]

    create_table :rs_reputation_messages do |t|
      t.references  :sender, :polymorphic => true
      t.integer     :receiver_id
      t.float       :weight, :default => 1
      t.timestamps
    end

    add_index :rs_reputation_messages, [:sender_id, :sender_type]
    add_index :rs_reputation_messages, :receiver_id
  end

  def self.down
    drop_table :rs_evaluations
    drop_table :rs_reputations
    drop_table :rs_reputation_messages
  end
end
