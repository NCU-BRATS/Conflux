class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include FriendlyId
  include EventableConcern
  friendly_id :name, use: :slugged

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :group_participations
  has_many :groups, through: :group_participations

  has_many :project_participations
  has_many :projects, through: :project_participations

  has_many :issues
  has_many :issues_assigned, class_name: 'Issue', foreign_key: 'assignee_id'
  has_many :sprints
  has_many :comments
  has_many :attachments
  has_many :posts
  has_many :images
  has_many :snippets
  has_many :other_attachments
  has_many :participations
  has_many :feedbacks

  has_many :events,        dependent: :destroy, foreign_key: :author_id,   class_name: 'Event'
  has_many :recent_events, -> { order 'id DESC' }, foreign_key: :author_id,   class_name: 'Event'
  has_many :notices,        dependent: :destroy, foreign_key: :owner_id,   class_name: 'Notice'
  has_many :recent_notices, -> { order 'id DESC' }, foreign_key: :owner_id,   class_name: 'Notice'

  has_reputation :likes, source:{reputation: :likes, of: :comments}, aggregated_by: :sum
  has_reputation :likes, source:{reputation: :likes, of: :attachments}, aggregated_by: :sum

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, format: { with: /\A[a-zA-Z][a-zA-Z0-9_]+\Z/, message: I18n.t('validation.slug.format') }
  validates :mention_email_enabled, inclusion: { in: [true, false] }
  validates :participating_email_enabled, inclusion: { in: [true, false] }
  validates :watch_email_enabled, inclusion: { in: [true, false] }
  validates :notification_level, inclusion: { in: Notification.notification_levels }, presence: true

  default_value_for :notification_level, Notification::N_PARTICIPATING

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def is_member?(project)
    @is_member = project.has_member?(self) if @is_member.nil?
    @is_member
  end

  def notification
    @notification ||= Notification.new(self)
  end

  def after_confirmation
    pendings = PendingMember.includes(:inviter, :project).where(invitee_email: self.email)
    pendings.each do |pending|
      @form = ProjectParticipationOperation::Create.new(pending.inviter, pending.project)
      @form.process(ActionController::Parameters.new({project_participation: {user_id: self.id}}))
      pending.destroy
    end
  end

end
