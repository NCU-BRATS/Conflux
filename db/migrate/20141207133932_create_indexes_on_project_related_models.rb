class CreateIndexesOnProjectRelatedModels < ActiveRecord::Migration
  def change
    add_index :users, :name, :unique => true

    add_index :projects, :name, :unique => true

    add_index :users_projects, :user_id
    add_index :users_projects, :project_id

    add_index :issues, :project_id
    add_index :issues, :user_id
    add_index :issues, :sprint_id

    add_index :users_issues, :user_id
    add_index :users_issues, :issue_id

    add_index :sprints, :project_id
    add_index :sprints, :user_id

    add_index :comments, :user_id
    add_index :comments, [:commentable_id, :commentable_type]

    add_index :repositories, :project_id

    add_index :groups, :leader_id

    add_index :users_groups, :user_id
    add_index :users_groups, :group_id
  end
end
