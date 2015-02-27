class AddNotificationLevelToUsersProjects < ActiveRecord::Migration
  def change
    add_column :users_projects, :notification_level, :integer
  end
end
