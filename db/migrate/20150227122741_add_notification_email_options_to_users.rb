class AddNotificationEmailOptionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mention_email, :boolean, default: true
    add_column :users, :participating_email, :boolean, default: true
    add_column :users, :watch_email, :boolean, default: true
  end
end
