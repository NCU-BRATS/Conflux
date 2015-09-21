class CreateAccessLogs < ActiveRecord::Migration
  def change
    create_table :access_logs do |t|
      t.integer :user_id
      t.string :session_id
      t.string :path
      t.string :controller
      t.string :action
      t.string :format
      t.string :remote_ip
      t.jsonb :headers
      t.jsonb :params

      t.timestamps null: false
    end
  end
end
