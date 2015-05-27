module IssueOperation
  class BaseForm < Reform::Form
    include Composition

    model :issue

    property :title,       on: :issue
    property :begin_at,    on: :issue
    property :due_at,      on: :issue
    property :status,      on: :issue
    property :assignee_id, on: :issue
    property :sprint_id,   on: :issue
    property :label_ids,   on: :issue

    validates :title, presence: true

    private

    def mention_service
      MentionService.new
    end

  end
end
