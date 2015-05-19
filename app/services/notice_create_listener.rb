class NoticeCreateListener
  class << self
    def on_issue_created(issue, current_user)
      create_notice(issue, current_user, :created)
    end

    def on_issue_closed(issue, current_user)
      create_notice(issue, current_user, :closed)
    end

    def on_issue_reopened(issue, current_user)
      create_notice(issue, current_user, :reopened)
    end

    def on_sprint_created(sprint, current_user)
      create_notice(sprint, current_user, :created)
    end

    def on_sprint_closed(sprint, current_user)
      create_notice(sprint, current_user, :closed)
    end

    def on_sprint_reopened(sprint, current_user)
      create_notice(sprint, current_user, :reopened)
    end

    def on_poll_created(poll, current_user)
      create_notice(poll, current_user, :created)
    end

    def on_poll_closed(poll, current_user)
      create_notice(poll, current_user, :closed)
    end

    def on_poll_reopened(poll, current_user)
      create_notice(poll, current_user, :reopened)
    end

    def on_comment_created(comment, current_user)
      create_comment_notice(comment, current_user, :commented)
    end

    def on_comment_deleted(comment, current_user)
      # create_comment_notice(comment, current_user, :deleted)
    end

    def on_attachment_created(attachment, current_user)
      create_notice(attachment, current_user, :uploaded)
    end

    def on_attachment_deleted(attachment, current_user)
      # create_notice(attachment, current_user, :deleted)
    end

    def on_channel_created(channel, current_user)
      create_notice(channel, current_user, :created)
    end

    def on_channel_deleted(channel, current_user)
      # create_notice(channel, current_user, :deleted)
    end

    def create_mention_notice(record, current_user, mentioner)
      Notice.create(
          target_id: record.id,
          target_type: record.class.name,
          target_json: record.to_target_json,
          project: record.project,
          action: :mention,
          state: :unseal,
          mode: :unread,
          author_id: current_user.id,
          owner_id: mentioner.id
      )
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
end
