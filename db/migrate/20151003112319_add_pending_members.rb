class AddPendingMembers < ActiveRecord::Migration
  def change
    create_table :pending_members do |t|
      t.integer :project_id, index: true
      t.integer :inviter_id, index: true
      t.string  :invitee_email

      t.timestamps null: false
    end
  end
end
