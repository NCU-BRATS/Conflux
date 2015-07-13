require 'rails_helper'

RSpec.describe PollMentionService do

  include_context 'project with members and polls'
  include Rails.application.routes.url_helpers

  describe '#process' do
    context do

      before(:example) do
        @poll_mention_service = PollMentionService.new
      end

      it 'replaces pattern ^POLL_ID with a link to the poll' do
        link_0 = "<a href=\"#{project_poll_path(@project, @polls[0])}\" class=\"poll-mention\">^#{@polls[0].sequential_id}</a>"
        link_1 = "<a href=\"#{project_poll_path(@project, @polls[1])}\" class=\"poll-mention\">^#{@polls[1].sequential_id}</a>"

        parse_result = @poll_mention_service.parse_mention(
            "This is a test comment which references ^#{@polls[0].sequential_id} and ^#{@polls[1].sequential_id}",
            @project
        )
        expect(parse_result[:filtered_content]).to eq(
          "This is a test comment which references #{link_0} and #{link_1}"
        )
      end

      it 'would not replaced pattern ^POLL_ID with a link if poll is not exist' do
        paragraph = "This is a test comment which references ^NOT_EXIST_POLL."
        parse_result = @poll_mention_service.parse_mention(paragraph, @project)
        expect(parse_result[:filtered_content]).to eq(paragraph)
      end

      it 'would return the polls it parsed out' do
        parse_result = @poll_mention_service.parse_mention(
            "This is a test comment which references ^#{@polls[0].sequential_id} and ^#{@polls[1].sequential_id}",
            @project
        )
        expect(parse_result[:mentioned_polls]).to eq([ @polls[0], @polls[1] ])
      end

      it 'would not return the polls if polls are not exist' do
        paragraph = "This is a test comment which references ^NOT_EXIST_POLL."
        parse_result = @poll_mention_service.parse_mention(paragraph, @project)
        expect(parse_result[:mentioned_polls]).to eq([])
      end

    end
  end
end
