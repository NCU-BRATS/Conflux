module IssueOperation
  class BaseForm < Reform::Form

    model :issue

    property :title
    property :begin_at
    property :due_at
    property :status
    property :assignee_id
    property :sprint_id
    property :label_ids

    validates :title, presence: true

    def issue_params(params)
      params.require(:issue)
    end

  end
end
