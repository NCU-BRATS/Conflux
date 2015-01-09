class DropUsersIssues < ActiveRecord::Migration
  def up
    remove_index :users_issues, :user_id
    remove_index :users_issues, :issue_id
    drop_table :users_issues

    add_column :issues, :assignee_id, :integer
    add_index :issues, :assignee_id
  end

  def down
    remove_index :issues, :assignee_id
    remove_column :issues, :assignee_id

    create_table :users_issues do |t|
      t.references :user
      t.references :issue
      t.timestamps
    end

    add_index :users_issues, :user_id
    add_index :users_issues, :issue_id
  end
end
