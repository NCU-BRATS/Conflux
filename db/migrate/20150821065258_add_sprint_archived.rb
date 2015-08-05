class AddSprintArchived < ActiveRecord::Migration
  def change
    add_column :sprints, :archived, :boolean, default: false
  end
end
