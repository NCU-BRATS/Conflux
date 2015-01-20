class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :name
      t.text :content
      t.string :type
      t.string :path
      t.string :language
      t.references :project
      t.references :user
      t.timestamps
    end
  end
end
