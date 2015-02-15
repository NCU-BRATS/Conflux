class Channel < ActiveRecord::Base
  include FriendlyId
  include ParserConcern

  sync :all

  friendly_id :name, use: :slugged

  belongs_to :project

  has_many :channel_participations, dependent: :destroy
  has_many :members, through: :channel_participations, source: :user
  has_many :messages, dependent: :destroy

  validates :name, :project, presence: true

  before_save :parse_announcement, if: :announcement_changed?

  def parse_announcement
    self.html = self.class.parse announcement
  end

end