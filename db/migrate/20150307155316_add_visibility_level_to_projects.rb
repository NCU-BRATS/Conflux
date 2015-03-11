class AddVisibilityLevelToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :visibility_level, :integer

    Project.update_all("visibility_level = 0")
  end
end
