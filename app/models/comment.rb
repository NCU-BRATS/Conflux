class Comment < ActiveRecord::Base
  include ParserConcern
  include ParticipableConcern

  sync :all

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  participate_by [:user] do |instance|
    instance.commentable
  end

  validates :content, :user, presence: true

  before_save :parse_content, if: :content_changed?

  delegate :project, to: :commentable

  scope :asc, -> { order(:created_at) }

  sync_scope :by_commentable, ->(commentable){ where( commentable_type: commentable.class.base_class.name, commentable_id: commentable.id ) }

  def parse_content
    self.html = self.class.parse content
  end

end
