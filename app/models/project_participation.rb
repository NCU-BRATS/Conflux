class ProjectParticipation < ActiveRecord::Base
  self.table_name = 'users_projects'

  belongs_to :user
  belongs_to :project

  validates :user, presence: true
  validates :project, presence: true
end
