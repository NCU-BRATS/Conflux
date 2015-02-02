class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string   "target_type"
      t.integer  "target_id"
      t.string   "title"
      t.integer  "project_id"
      t.integer  "action"
      t.integer  "author_id"
      t.timestamps null: false
    end
  end
end
