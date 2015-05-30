class NoticeCreateListener
  class << self
    def on_issue_created(issue, current_user)
      mentioned_members = issue.comments.first.mentioned_list['members']
      create_notice_without_mentioned(issue, current_user, :created, mentioned_members)
    end

    def on_issue_closed(issue, current_user)
      create_notice(issue, current_user, :closed)
    end

    def on_issue_reopened(issue, current_user)
      create_notice(issue, current_user, :reopened)
    end

    def on_sprint_created(sprint, current_user)
      mentioned_members = sprint.comments.first.mentioned_list['members']
      create_notice_without_mentioned(sprint, current_user, :created, mentioned_members)
    end

    def on_sprint_closed(sprint, current_user)
      create_notice(sprint, current_user, :closed)
    end

    def on_sprint_reopened(sprint, current_user)
      create_notice(sprint, current_user, :reopened)
    end

    def on_poll_created(poll, current_user)
      mentioned_members = poll.comments.first.mentioned_list['members']
      create_notice_without_mentioned(poll, current_user, :created, mentioned_members)
    end

    def on_poll_closed(poll, current_user)
      create_notice(poll, current_user, :closed)
    end

    def on_poll_reopened(poll, current_user)
      create_notice(poll, current_user, :reopened)
    end

    def on_comment_created(comment, current_user)
      create_comment_notice(comment, current_user, :commented)
      create_all_mentioned_notice(comment, current_user)
    end

    def on_comment_updated(comment, mentioned_list, current_user)
      create_new_mentioned_notice(comment, mentioned_list, current_user) if mentioned_list
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
      # create_notice(channel, current_user, :created)
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

    def create_notice_without_mentioned(record, current_user, status, mentioned)
      recipients = build_recipients(record, current_user, record.project)
      recipients.select! { |recipient| mentioned.exclude?(recipient.id) }
      send_notice(recipients, record, current_user, status)
    end

    def create_all_mentioned_notice(record, current_user)
      User.find(record.mentioned_list['members']).each do |mentioned_member|
        create_mention_notice(record, current_user, mentioned_member)
      end
    end

    def create_new_mentioned_notice(record, mentioned_list, current_user)
      old_mentioned_list = mentioned_list[0] # mentioned_list before model saved
      new_mentioned_list = mentioned_list[1] # mentioned_list after model saved
      new_mentioned_list.each do |key, value|
        new_mentioned = value - old_mentioned_list[key]
        if key == 'members'
          User.find(new_mentioned).each do |mentioned_member|
            create_mention_notice(record, current_user, mentioned_member)
          end
        end
      end
    end

    def create_comment_notice(record, current_user, status)
      recipients = build_recipients(record.commentable, current_user, record.project)
      recipients.select! { |recipient| record.mentioned_list['members'].exclude?(recipient.id) }
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
