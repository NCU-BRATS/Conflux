class MemberMentionService
  include Rails.application.routes.url_helpers

  def initialize
    @member_mention_filter = MentionFilters::MemberMentionFilter.new
  end

  def parse_mention(text)
    mentioned_members = []

    filtered_field = @member_mention_filter.filter(text) do |match, target|
      member = User.find_by_name(target)
      mentioned_members << member if member
      link = link_to_mentioned_member(member)
      link ? match.sub("#{@member_mention_filter.mention_character}#{target}", link) : match
    end

    { filtered_content: filtered_field, mentioned_members: mentioned_members }
  end

  def link_to_mentioned_member(member)
    return nil unless member
    url = user_path(member)
    "<a href='#{url}' class='user-mention'>#{@member_mention_filter.mention_character}#{member.name}</a>"
  end

end
