module SprintOperation
  class BaseForm < Reform::Form

    model :sprint

    property :title
    property :begin_at
    property :due_at
    property :status
    property :issue_ids
    property :statuses
    property :archived

    validates :title, presence: true

    def sprint_params(params)
      params.require(:sprint)
    end

  end
end
