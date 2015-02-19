class AddPostSnippetImageOtherCountToProject < ActiveRecord::Migration
  def change
    add_column :projects, :posts_count, :integer, null: false, default: 0
    add_column :projects, :snippets_count, :integer, null: false, default: 0
    add_column :projects, :images_count, :integer, null: false, default: 0
    add_column :projects, :other_attachments_count, :integer, null: false, default: 0
  end
end
