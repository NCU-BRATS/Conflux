class Sprint < ActiveRecord::Base
  class Create < BaseForm
    property :content,     on: :comment
    validates :content, presence: true

    def initialize(current_user, project, sprint = Sprint.new, comment = Comment.new)
      @current_user = current_user
      @project      = project
      super({sprint: sprint, comment: comment})
    end

    def process(params)
      sprint, comment = @model[:sprint], @model[:comment]
      if validate(params[:sprint].except(:issue_ids)) && sync
        comment.user   = @current_user
        sprint.user    = @current_user
        sprint.project = @project
        sprint.comments << comment
        if sprint.save
          sprint.update_attributes(issue_ids: params[:sprint][:issue_ids])
          event_service.open_sprint(sprint, @current_user)
          notice_service.open_sprint(sprint, @current_user)
          mention_service.mention_filter(:html, comment)
        end
      end
    end
  end
end
