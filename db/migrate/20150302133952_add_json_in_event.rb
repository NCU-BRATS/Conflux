class AddJsonInEvent < ActiveRecord::Migration
  def change
    add_column :events, :target_json, :jsonb, null: false, default: '{}'
  end
end
