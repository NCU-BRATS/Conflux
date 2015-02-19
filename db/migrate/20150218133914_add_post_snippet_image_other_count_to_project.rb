class AddPostSnippetImageOtherCountToProject < ActiveRecord::Migration
  def change
    add_column :projects, :posts_count, :integer, null: false, default: 0
    add_column :projects, :snippets_count, :integer, null: false, default: 0
    add_column :projects, :images_count, :integer, null: false, default: 0
    add_column :projects, :other_attachments_count, :integer, null: false, default: 0

    Project.all.each do |p|
      p.posts_count    = p.posts.count
      p.snippets_count = p.snippets.count
      p.images_count   = p.images.count
      p.other_attachments_count = p.other_attachments.count
      p.save
    end
  end
end
