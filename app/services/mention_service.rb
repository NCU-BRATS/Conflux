class MentionService

  def mention_filter(field, mentionable)
    member_mention_service.mention_member(field, mentionable)
    issue_mention_service.mention_issue(field, mentionable)
  end

  private

  def member_mention_service
    @member_mention_service ||= MemberMentionService.new
  end

  def issue_mention_service
    @issue_mention_service ||= IssueMentionService.new
  end

end
