class Message < ActiveRecord::Base
  include ParserConcern

  sync :all

  belongs_to :user
  belongs_to :channel

  validates :content, :user, presence: true

  before_save :parse_content, if: :content_changed?

  delegate :project, to: :channel

  default_scope { order(:created_at) }

  sync_scope :by_channel, ->(channel){ where( channel_id: channel.id ) }

  def parse_content
    self.html = self.class.parse content
  end

end
