class NoticeCreateListener
  class << self
    def on_issue_created(issue, current_user)
      # create_notice(issue, current_user, :created)
    end

    def on_sprint_created(sprint, current_user)
      # create_notice(sprint, current_user, :created)
    end

    def on_poll_created(poll, current_user)
      # create_notice(poll, current_user, :created)
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
      # create_notice(attachment, current_user, :uploaded)
    end

    def on_attachment_deleted(project, type, attachment, current_user)
      # create_notice(attachment, current_user, :deleted)
    end

    def on_channel_created(channel, current_user)
      # create_notice(channel, current_user, :created)
    end

    def on_channel_deleted(channel, current_user)
      # create_notice(channel, current_user, :deleted)
    end

    private

    def create_notice(record, current_user, status)
      recipients = build_recipients(record, current_user, record.project)
      send_notice(recipients, record, current_user, status)
    end

    def create_all_mentioned_notice(record, current_user)
      send_notice(User.find(record.mentioned_list['members']), record, current_user, :mention)
    end

    def create_new_mentioned_notice(record, mentioned_list, current_user)
      old_list, new_list = mentioned_list

      return if old_list.nil? || new_list.nil?

      new_mentioned = new_list.fetch('members', []) - old_list.fetch('members', [])
      send_notice(User.find(new_mentioned), record, current_user, :mention)
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
        PrivatePub.publish_to("/users/#{recipient.id}", {
          action: 'count',
          target: 'notices'
        })
      end
    end

    def build_recipients(target, current_user, project)
      # 1. 撈出 project 底下所有的 project_participations
      # 2. 撈出 project 底下所有的 members
      # 3. 撈出 issue 底下所有的 participations
      # 4. 針對 issue 底下所有的每個 participation 去檢查 subscribed?
      #     檢查方法：檢查這個人他的 project_participations 裡面的 notification_level 是不是 3(default)
      #       如果是，就去看 user 的 notification_level
      #       如果 notification_level 是 participation 或是 watch 就放入那個空 array ，其餘移除
      # 5. 對於剩下的 member，檢查他是不是 watch project
      recipients = []
      project_participations = project.project_participations.includes(:user).to_a
      members = project_participations.map(&:user)
      participations = target.participations

      participations.each do |p|
        pp = project_participations.find {|pp| pp.user_id == p.user_id }
        mm = members.find {|m| m.id == pp.user_id }
        recipients << mm if subscribed?(pp, mm)
        project_participations -= [pp]
      end

      project_participations.each do |pp|
        mm = members.find {|m| m.id == pp.user_id }
        recipients << mm if subscribed?(pp, mm)
      end

      recipients - [current_user]
    end

    def subscribed?(project_participation, member)
      target = (project_participation.notification_level == 3) ? member : project_participation
      target.notification_level == 1 || target.notification_level == 2
    end
  end
end
