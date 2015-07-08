require 'rails_helper'

RSpec.describe IssueMentionService do

  include_context 'project with members and issues'
  include Rails.application.routes.url_helpers

  describe '#process' do
    context do

      before(:example) do
        @issue_mention_service = IssueMentionService.new
      end

      it 'replaces pattern @ISSUE_ID with a link to the issue' do
        link_0 = "<a href=\"#{project_issue_path(@project, @issues[0])}\" class=\"issue-mention\">##{@issues[0].sequential_id}</a>"
        link_1 = "<a href=\"#{project_issue_path(@project, @issues[1])}\" class=\"issue-mention\">##{@issues[1].sequential_id}</a>"

        parse_result = @issue_mention_service.parse_mention(
            "This is a test comment which references ##{@issues[0].sequential_id} and ##{@issues[1].sequential_id}",
            @project
        )
        expect(parse_result[:filterd_content]).to eq(
          "This is a test comment which references #{link_0} and #{link_1}"
        )
      end

      it 'would not replaced pattern @ISSUE_ID with a link if issue is not exist' do
        paragraph = "This is a test comment which references #NOT_EXIST_ISSUE."
        parse_result = @issue_mention_service.parse_mention(paragraph, @project)
        expect(parse_result[:filterd_content]).to eq(paragraph)
      end

      it 'would return the issues it parsed out' do
        parse_result = @issue_mention_service.parse_mention(
            "This is a test comment which references ##{@issues[0].sequential_id} and ##{@issues[1].sequential_id}",
            @project
        )
        expect(parse_result[:mentioned_issues]).to eq([ @issues[0], @issues[1] ])
      end

      it 'would not return the issues if issues are not exist' do
        paragraph = "This is a test comment which references #NOT_EXIST_ISSUE."
        parse_result = @issue_mention_service.parse_mention(paragraph, @project)
        expect(parse_result[:mentioned_issues]).to eq([])
      end

    end
  end
end
