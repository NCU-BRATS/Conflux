class Issue < ActiveRecord::Base
  include ParserConcern
  include ParticipableConcern
  include CommentableConcern
  include LabelableConcern
  include EventableConcern
  include PlannableConcern

  belongs_to :project
  belongs_to :user
  belongs_to :sprint
  belongs_to :assignee, class_name: 'User'

  update_index('projects#issue')  { self }
  update_index('projects#sprint') { sprint if sprint.present? }

  counter_culture :sprint

  acts_as_sequenced scope: :project_id

  validates :title, :status, :project, :sprint, :user, presence: true

  before_save :parse_content

  def parse_content
    self.memo_html = self.class.parse memo
  end

  def to_param
    self.sequential_id.to_s
  end

  def self.commentable_find_key
    :sequential_id
  end

  def done?
    status == '2'
  end

end
