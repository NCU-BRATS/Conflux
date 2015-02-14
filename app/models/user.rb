class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include FriendlyId
  friendly_id :name, use: :slugged

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :group_participations
  has_many :groups, through: :group_participations

  has_many :project_participations
  has_many :projects, through: :project_participations

  has_many :issues
  has_many :issues_assigned, class_name: 'Issue', foreign_key: 'assignee_id'
  has_many :sprints
  has_many :comments
  has_many :attachments
  has_many :posts,    class_name: 'Attachment::Post'
  has_many :images,   class_name: 'Attachment::Image'
  has_many :snippets, class_name: 'Attachment::Snippet'

  has_many :events,        dependent: :destroy, foreign_key: :author_id,   class_name: "Event"
  has_many :recent_events, -> { order "id DESC" }, foreign_key: :author_id,   class_name: "Event"

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, format: { with: /[A-Za-z0-9_]/, message: I18n.t('validation.user.format') }

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def is_member?(project)
    @is_member = project.has_member?(self) if @is_member.nil?
    @is_member
  end

end
