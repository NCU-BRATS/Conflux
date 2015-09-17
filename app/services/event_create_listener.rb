class EventCreateListener
  class << self
    def on_issue_created(issue, current_user)
      create_event(issue, current_user, :created)
    end

    def on_issue_closed(issue, current_user)
      create_event(issue, current_user, :closed)
    end

    def on_issue_reopened(issue, current_user)
      create_event(issue, current_user, :reopened)
    end

    def on_sprint_created(sprint, current_user)
      create_event(sprint, current_user, :created)
    end

    def on_sprint_closed(sprint, current_user)
      create_event(sprint, current_user, :closed)
    end

    def on_sprint_reopened(sprint, current_user)
      create_event(sprint, current_user, :reopened)
    end

    def on_poll_created(poll, current_user)
      create_event(poll, current_user, :created)
    end

    def on_poll_closed(poll, current_user)
      create_event(poll, current_user, :closed)
    end

    def on_poll_reopened(poll, current_user)
      create_event(poll, current_user, :reopened)
    end

    def on_comment_created(comment, current_user)
      create_event(comment, current_user, :commented)
    end

    def on_comment_deleted(comment, current_user)
      # create_event(comment, current_user, :deleted)
    end

    def on_attachment_created(attachment, current_user)
      create_event(attachment, current_user, :uploaded)
    end

    def on_attachment_deleted(project, type, attachment, current_user)
      create_delete_event(project, type, attachment, current_user, :deleted)
    end

    def on_project_participation_created(participation, current_user)
      create_member_event(participation, current_user, :joined)
    end

    def on_project_participation_deleted(project, user, current_user)
      create_member_delete_event(project, user, current_user, :left)
    end

    def on_channel_created(channel, current_user)
      create_event(channel, current_user, :created)
    end

    def on_channel_deleted(channel, current_user)
      # create_event(channel, current_user, :deleted)
    end

    private

    def create_member_event(record, current_user, status)
      Event.create(
          project: record.project,
          target_id: record.user.id,
          target_type: record.user.class.name,
          target_json: record.user.to_target_json,
          action: status,
          author_id: current_user.id
      )
    end

    def create_member_delete_event(project, user, current_user, status)
      Event.create(
          project: project,
          target_id: user.id,
          target_type: user.class.name,
          target_json: user.to_target_json,
          action: status,
          author_id: current_user.id
      )
    end

    def create_event(record, current_user, status)
      Event.create(
          project: record.project,
          target_id: record.id,
          target_type: record.class.name,
          target_json: record.to_target_json,
          action: status,
          author_id: current_user.id
      )
    end

    def create_delete_event(project, type, record, current_user, status)
      Event.create(
          project: project,
          target_type: type,
          target_json: record,
          action: status,
          author_id: current_user.id
      )
    end
  end
end
