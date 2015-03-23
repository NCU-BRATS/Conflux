class ChangeReputationMessagesIndexToUnique < ActiveRecord::Migration
  def self.up
    remove_index :rs_reputation_messages, :name => "index_rs_reputation_messages_on_receiver_id_and_sender"
    add_index :rs_reputation_messages, [:receiver_id, :sender_id, :sender_type], :name => "index_rs_reputation_messages_on_receiver_id_and_sender", :unique => true
  end

  def self.down
    remove_index :rs_reputation_messages, :name => "index_rs_reputation_messages_on_receiver_id_and_sender"
    add_index :rs_reputation_messages, [:receiver_id, :sender_id, :sender_type], :name => "index_rs_reputation_messages_on_receiver_id_and_sender"
  end
end

