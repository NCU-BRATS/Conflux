module SyncableConcern
  extend ActiveSupport::Concern

  included do
    sync :all
    sync_scope :by_project, ->(project_id) { where(project_id: project_id) }
  end
end
