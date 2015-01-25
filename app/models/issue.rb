class Issue < ActiveRecord::Base
  include AASM
  include ParserConcern
  include CommentableConcern

  sync :all

  belongs_to :project
  belongs_to :user
  belongs_to :sprint
  belongs_to :assignee, class_name: 'User'
  has_many :label_links, as: :target, dependent: :destroy
  has_many :labels, through: :label_links

  acts_as_sequenced scope: :project_id

  accepts_nested_attributes_for :comments

  aasm :column => 'status' do

    state :open, :initial => true
    state :closed

    event :close do
      transitions :from => :open, :to => :closed
    end

    event :reopen do
      transitions :from => :closed, :to => :open
    end

  end

  validates :title, :status, :project, :user, presence: true

  def to_param
    self.sequential_id.to_s
  end

  def self.commentable_find_key
    :sequential_id
  end

  def label_names
    labels.order('title ASC').pluck(:title)
  end

  def remove_labels
    labels.delete_all
  end

  def add_labels_by_names(label_names)
    label_names.each do |label_name|
      label = project.labels.create_with(
          color: Label::DEFAULT_COLOR).find_or_create_by(title: label_name.strip)
      self.labels << label
    end
  end

end
