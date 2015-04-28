class AddResultsToPoll < ActiveRecord::Migration
  def change
    add_column :polls, :results, :jsonb, default: []
  end
end
