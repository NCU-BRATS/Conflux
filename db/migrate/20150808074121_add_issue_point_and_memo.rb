class AddIssuePointAndMemo < ActiveRecord::Migration
  def change
    add_column :issues, :point, :integer, default: 0
    add_column :issues, :memo, :text
    add_column :issues, :memo_html, :text
  end
end
