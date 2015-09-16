class Message < ActiveRecord::Base
  include ParserConcern

  belongs_to :user
  belongs_to :channel

  validates :content, :user, presence: true

  before_save :parse_content, if: :content_changed?

  update_index('projects#message') { self if should_reindex? }
  acts_as_sequenced scope: :channel_id

  delegate :project, to: :channel

  def parse_content
    self.html = self.class.parse content
  end

  def should_reindex?
    destroyed? || (previous_changes.keys & ['content']).present?
  end

  def to_param
    self.sequential_id.to_s
  end

end
