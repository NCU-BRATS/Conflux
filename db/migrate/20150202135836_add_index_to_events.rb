class AddIndexToEvents < ActiveRecord::Migration
  def change
    add_index "events", ["action"], name: "index_events_on_action", using: :btree
    add_index "events", ["author_id"], name: "index_events_on_author_id", using: :btree
    add_index "events", ["project_id"], name: "index_events_on_project_id", using: :btree
    add_index "events", ["target_id"], name: "index_events_on_target_id", using: :btree
    add_index "events", ["target_type"], name: "index_events_on_target_type", using: :btree
  end
end
