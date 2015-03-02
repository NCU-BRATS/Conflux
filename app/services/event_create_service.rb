class EventCreateService
  def open_issue(issue, current_user)
    create_event(issue, current_user, :created)
  end

  def close_issue(issue, current_user)
    create_event(issue, current_user, :closed)
  end

  def reopen_issue(issue, current_user)
    create_event(issue, current_user, :reopened)
  end

  def open_sprint(sprint, current_user)
    create_event(sprint, current_user, :created)
  end

  def close_sprint(sprint, current_user)
    create_event(sprint, current_user, :closed)
  end

  def reopen_sprint(sprint, current_user)
    create_event(sprint, current_user, :reopened)
  end

  def leave_comment(comment, current_user)
    create_event(comment, current_user, :commented)
  end

  def delete_comment(comment, current_user)
    create_event(comment, current_user, :deleted)
  end

  def upload_attachment(attachment, current_user)
    create_event(attachment, current_user, :uploaded)
  end

  def delete_attachment(attachment, current_user)
    create_event(attachment, current_user, :deleted)
  end

  def join_project(participation, current_user)
    create_member_event(participation, current_user, :joined)
  end

  def left_project(participation, current_user)
    create_member_event(participation, current_user, :left)
  end

  private

  def create_member_event(record, current_user, status)
    Event.create(
        project: record.project,
        target_id: record.user.id,
        target_type: record.user.class.name,
        action: status,
        author_id: current_user.id
    )
  end

  def create_event(record, current_user, status)
    Event.create(
        project: record.project,
        target_id: record.id,
        target_type: record.class.name,
        action: status,
        author_id: current_user.id
    )
  end
end