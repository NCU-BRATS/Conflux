class PollingOption < ActiveRecord::Base
  acts_as_votable

  belongs_to :poll

  validates :title, presence: true

  update_index('projects#poll') { poll if should_reindex? }

  def should_reindex?
    destroyed? || (previous_changes.keys & ['title', 'cached_votes_total']).present?
  end

end
