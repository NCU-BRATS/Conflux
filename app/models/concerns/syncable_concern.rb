module SyncableConcern
  extend ActiveSupport::Concern

  included do
    sync :all
    sync_scope :by_project, ->(project) { where(project_id: project.id) }
  end
end
