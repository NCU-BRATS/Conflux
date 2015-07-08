require 'rails_helper'

RSpec.describe MemberMentionService do

  include_context 'project with members'
  include Rails.application.routes.url_helpers

  describe '#process' do

    before(:example) do
      @member_mention_service = MemberMentionService.new
    end

    it 'replaces pattern @USER_NAME with a link to user profile' do
      link_0 = "<a href=\"#{user_path(@members[0])}\" class=\"user-mention\">@#{@members[0].name}</a>"
      link_1 = "<a href=\"#{user_path(@members[1])}\" class=\"user-mention\">@#{@members[1].name}</a>"

      parse_result = @member_mention_service.parse_mention("This is a test comment which references @#{@members[0].name} and @#{@members[1].name}")
      expect(parse_result[:filterd_content]).to eq(
        "This is a test comment which references #{link_0} and #{link_1}"
      )
    end

    it 'would not replaced pattern @USER_NAME with a link if user is not exist' do
      paragraph = "This is a test comment which references @NOT_EXIST_USER."
      parse_result = @member_mention_service.parse_mention(paragraph)
      expect(parse_result[:filterd_content]).to eq(paragraph)
    end

    it 'would return the users it parsed out' do
      parse_result = @member_mention_service.parse_mention("This is a test comment which references @#{@members[0].name} and @#{@members[1].name}")
      expect(parse_result[:mentioned_members]).to eq([ @members[0], @members[1] ])
    end

    it 'would not return the users if users are not exist' do
      paragraph = "This is a test comment which references @NOT_EXIST_USER."
      parse_result = @member_mention_service.parse_mention(paragraph)
      expect(parse_result[:mentioned_members]).to eq([])
    end

  end
end
