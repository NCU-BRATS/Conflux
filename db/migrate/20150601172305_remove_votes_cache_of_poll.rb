class RemoveVotesCacheOfPoll < ActiveRecord::Migration
  def change
    remove_column :polling_options, :cached_votes_total,      :integer, index: true, default: 0
    remove_column :polling_options, :cached_votes_score,      :integer, index: true, default: 0
    remove_column :polling_options, :cached_votes_up,         :integer, index: true, default: 0
    remove_column :polling_options, :cached_votes_down,       :integer, index: true, default: 0
    remove_column :polling_options, :cached_weighted_score,   :integer, index: true, default: 0
    remove_column :polling_options, :cached_weighted_total,   :integer, index: true, default: 0
    remove_column :polling_options, :cached_weighted_average, :float,   index: true, default: 0.0
    add_column    :polling_options, :voted_users,  :jsonb, default: []
  end
end
