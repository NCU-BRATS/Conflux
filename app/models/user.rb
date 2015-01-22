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

  has_many :issue_assigments
  has_many :assigned_issues, through: :issue_assigments, source: :issue

  has_many :issues
  has_many :sprints
  has_many :comments
  has_many :attachments

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, format: { with: /[A-Za-z0-9_]/, message: I18n.t('validation.user.format') }

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

end
