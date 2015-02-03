class AddHtmlToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :html , :text
  end
end
