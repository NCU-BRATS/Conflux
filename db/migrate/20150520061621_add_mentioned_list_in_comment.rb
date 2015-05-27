class AddMentionedListInComment < ActiveRecord::Migration
  def up
    add_column :comments, :mentioned_list, :json, default: "{}"
    Comment.all.update_all(mentioned_list: "{}")
  end

  def down
    remove_column :comments, :mentioned_list
  end
end
