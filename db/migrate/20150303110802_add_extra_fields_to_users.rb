class AddExtraFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :url, :string
    add_column :users, :github, :string
    add_column :users, :linkedin, :string
    add_column :users, :facebook, :string
    add_column :users, :twitter, :string
  end
end
