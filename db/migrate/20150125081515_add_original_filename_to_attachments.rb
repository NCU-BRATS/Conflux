class AddOriginalFilenameToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :original_filename, :string
  end
end
