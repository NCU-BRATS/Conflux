class AddNotificationLevelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notification_level, :integer
  end
end
