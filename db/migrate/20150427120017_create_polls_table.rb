class CreatePollsTable < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.integer :sequential_id
      t.string  :title
      t.string  :status
      t.boolean :allow_multiple_choice

      t.references :project, index: true
      t.references :user,    index: true

      t.timestamps
    end

    create_table :polling_options do |t|
      t.string     :title
      t.references :poll, index: true

      t.integer :cached_votes_total,      index: true, default: 0
      t.integer :cached_votes_score,      index: true, default: 0
      t.integer :cached_votes_up,         index: true, default: 0
      t.integer :cached_votes_down,       index: true, default: 0
      t.integer :cached_weighted_score,   index: true, default: 0
      t.integer :cached_weighted_total,   index: true, default: 0
      t.float   :cached_weighted_average, index: true, default: 0.0

      t.timestamps
    end
  end
end
