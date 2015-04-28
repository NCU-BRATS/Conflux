class MemberMentionService
  include Rails.application.routes.url_helpers

  def mention_member(field, mentionable)
    member_mention_filter = MentionFilters::MemberMentionFilter.new

    filtered_field = member_mention_filter.filter(mentionable.send(field)) do |match, target|
      member = User.find_by_name(target)
      link = link_to_mentioned_member(member)

      # Add the user to participation if the user isn't in participation
      unless mentionable.participations.exists?(user_id: member.id)
        mentionable.participations.create(user: member)
        # TODO: Create Notification
        # NotificationService.create_participating_notification(mentioned_user)
      end

      # TODO: Create Notification
      # NotificationService.create_mention_notification(member, mentionable)

      link ? match.sub("@#{target}", link) : match
    end

    mentionable.send("#{field.to_s}=".to_sym, filtered_field)
  end

  def link_to_mentioned_member(member)
    url = user_path(member)
    "<a href='#{url}' class='user-mention'>@#{member.name}</a>"
  end

end
