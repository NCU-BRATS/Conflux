module SprintOperation
  class BaseForm < Reform::Form

    model :sprint

    property :title
    property :begin_at
    property :due_at
    property :status
    property :issue_ids

    validates :title, presence: true

    private

    def mention_service
      MentionService.new
    end

  end
end
