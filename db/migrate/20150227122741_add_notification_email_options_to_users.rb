class AddNotificationEmailOptionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mention_email_enabled, :boolean, default: true
    add_column :users, :participating_email_enabled, :boolean, default: true
    add_column :users, :watch_email_enabled, :boolean, default: true
  end
end
