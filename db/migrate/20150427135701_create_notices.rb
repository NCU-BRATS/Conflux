class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string   "target_type"
      t.integer  "target_id"
      t.integer  "author_id"
      t.integer  "owner_id"
      t.integer  "project_id"
      t.integer  "action"
      t.integer  "state"
      t.integer  "mode"
      t.jsonb    "target_json", default: {}, null: false
      t.timestamps null: false
    end
    add_index "notices", ["action"], name: "index_notices_on_action", using: :btree
    add_index "notices", ["state"], name: "index_notices_on_state", using: :btree
    add_index "notices", ["mode"], name: "index_notices_on_mode", using: :btree
    add_index "notices", ["author_id"], name: "index_notices_on_author_id", using: :btree
    add_index "notices", ["owner_id"], name: "index_notices_on_owner_id", using: :btree
    add_index "notices", ["project_id"], name: "index_notices_on_project_id", using: :btree
    add_index "notices", ["target_id"], name: "index_notices_on_target_id", using: :btree
    add_index "notices", ["target_type"], name: "index_notices_on_target_type", using: :btree
  end
end