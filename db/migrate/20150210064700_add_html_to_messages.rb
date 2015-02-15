class AddHtmlToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :html , :text
  end
end
