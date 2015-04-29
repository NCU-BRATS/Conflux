class MemberMentionService
  include Rails.application.routes.url_helpers

  def mention_member(field, mentionable)
    member_mention_filter = MentionFilters::MemberMentionFilter.new

    mentioned_member = []

    filtered_field = member_mention_filter.filter(mentionable.send(field)) do |match, target|
      member = User.find_by_name(target)
      link = link_to_mentioned_member(member)

      # Add the user to participation if the user isn't in participation
      unless mentionable.participations.exists?(user_id: member.id)
        mentionable.participations.create(user: member)
      end

      # Prevent mention the same user multiple times
      unless mentioned_member.include?(member)
        notice_service.create_mention_notice(mentionable, mentionable.owner, member)
        mentioned_member << member
      end

      link ? match.sub("@#{target}", link) : match
    end

    mentionable.send("#{field.to_s}=".to_sym, filtered_field)
  end

  def link_to_mentioned_member(member)
    url = user_path(member)
    "<a href='#{url}' class='user-mention'>@#{member.name}</a>"
  end

  protected

  def notice_service
    @notice_service ||= NoticeCreateService.new
  end

end
