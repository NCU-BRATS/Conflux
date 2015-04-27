class NoticeCreateService
  def open_issue(issue, current_user)
    create_notice(issue, current_user, :created)
  end

  def close_issue(issue, current_user)
    create_notice(issue, current_user, :closed)
  end

  def reopen_issue(issue, current_user)
    create_notice(issue, current_user, :reopened)
  end

  def open_sprint(sprint, current_user)
    create_notice(sprint, current_user, :created)
  end

  def close_sprint(sprint, current_user)
    create_notice(sprint, current_user, :closed)
  end

  def reopen_sprint(sprint, current_user)
    create_notice(sprint, current_user, :reopened)
  end

  def leave_comment(comment, current_user)
    create_comment_notice(comment, current_user, :commented)
  end

  def delete_comment(comment, current_user)
    create_comment_notice(comment, current_user, :deleted)
  end

  def upload_attachment(attachment, current_user)
    create_notice(attachment, current_user, :uploaded)
  end

  def delete_attachment(attachment, current_user)
    create_notice(attachment, current_user, :deleted)
  end

  def create_channel(channel, current_user)
    create_notice(channel, current_user, :created)
  end

  def delete_channel(channel, current_user)
    create_notice(channel, current_user, :deleted)
  end

  private

  def create_notice(record, current_user, status)
    recipients = build_recipients(record, current_user, record.project)
    send_notice(recipients, record, current_user, status)
  end

  def create_comment_notice(record, current_user, status)
    recipients = build_recipients(record.commentable, current_user, record.project)
    send_notice(recipients, record, current_user, status)
  end

  def send_notice(recipients, record, current_user, status)
    recipients.each do |recipient|
      Notice.create(
          target_id: record.id,
          target_type: record.class.name,
          target_json: record.to_target_json,
          project: record.project,
          action: status,
          state: :unseal,
          mode: :unread,
          author_id: current_user.id,
          owner_id: recipient.id
      )
    end
  end

  def build_recipients(target, current_user, project)
    recipients = project.members.where(notification_level: 2)
    recipients = recipients - target.participations.unsubscribed.includes(:user).map(&:user)
    recipients = recipients + target.participations.subscribed.includes(:user).map(&:user).uniq
    recipients.delete(current_user)
    recipients
  end

end