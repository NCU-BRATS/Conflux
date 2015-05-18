class Issue < ActiveRecord::Base
  class Create < BaseForm
    property :content,     on: :comment
    validates :content, presence: true

    def initialize(current_user, project, issue = Issue.new, comment = Comment.new)
      @current_user = current_user
      @project      = project
      super({issue: issue, comment: comment})
    end

    def process(params)
      issue, comment = @model[:issue], @model[:comment]
      if validate(params[:issue].except(:label_ids)) && sync
        comment.user  = @current_user
        issue.user    = @current_user
        issue.project = @project
        issue.comments << comment
        if issue.save
          issue.update_attributes(label_ids: params[:issue][:label_ids])
          Participation::Create.new(@current_user, issue).process
          Participation::Create.new(issue.assignee, issue).process
          event_service.open_issue(issue, @current_user)
          notice_service.open_issue(issue, @current_user)
          mention_service.mention_filter(:html, comment)
        end
      end
    end
  end
end
