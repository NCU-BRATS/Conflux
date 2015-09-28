class RemoveLastReadMessageIdFromUsersChannels < ActiveRecord::Migration
  def change
    remove_column :users_channels, :last_read_message_id, :integer, index: true
    add_column :users_channels, :last_read_floor, :integer, default: 0
  end
end
