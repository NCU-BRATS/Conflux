class ProjectParticipation < ActiveRecord::Base
  include NotifiableConcern

  self.table_name = 'users_projects'

  belongs_to :user
  belongs_to :project

  validates :user, presence: true
  validates :project, presence: true
  validates :user, uniqueness: { scope: :project }
  default_value_for :notification_level, Notification::N_DEFAULT

end
