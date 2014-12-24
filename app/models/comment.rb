class Comment < ActiveRecord::Base
  include ParserConcern

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :content, :user, presence: true

  before_save :parse_content, if: :content_changed?

  def parse_content
    self.html = self.class.parse content
  end
end
