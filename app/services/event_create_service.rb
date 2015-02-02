class EventCreateService
  def open_issue(issue, current_user)
    create_event(issue, current_user, Event::CREATED)
  end

  def close_issue(issue, current_user)
    create_event(issue, current_user, Event::CLOSED)
  end

  def reopen_issue(issue, current_user)
    create_event(issue, current_user, Event::REOPENED)
  end

  def open_sprint(sprint, current_user)
    create_event(sprint, current_user, Event::CREATED)
  end

  def close_sprint(sprint, current_user)
    create_event(sprint, current_user, Event::CLOSED)
  end

  def reopen_sprint(sprint, current_user)
    create_event(sprint, current_user, Event::REOPENED)
  end

  def leave_comment(comment, current_user)
    create_event(comment, current_user, Event::COMMENTED)
  end

  private

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