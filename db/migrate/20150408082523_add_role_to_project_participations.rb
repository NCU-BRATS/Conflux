class AddRoleToProjectParticipations < ActiveRecord::Migration
  def change
    add_column :users_projects, :project_role_id  , :integer, null: true
    add_index :users_projects, :project_role_id
  end
end
