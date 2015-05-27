module SprintOperation
  class BaseForm < Reform::Form
    include Composition

    model :sprint

    property :title,       on: :sprint
    property :begin_at,    on: :sprint
    property :due_at,      on: :sprint
    property :status,      on: :sprint
    property :issue_ids,   on: :sprint

    validates :title, presence: true

    private

    def mention_service
      MentionService.new
    end

  end
end
