require 'rails_helper'

RSpec.describe MessageMentionService do

  include_context 'project with mentionable resources'
  include Rails.application.routes.url_helpers

  describe '#process' do
    context do

      before(:example) do
        @message_mention_service = MessageMentionService.new
      end

      it 'replaces pattern :CHANNEL_ID-MESSAGE_ID with a link to the message' do
        link_0 = "<a href=\"#{project_channel_path(@project, @channels[0].slug)}##{@messages[0].sequential_id}\" class=\"message-mention\">:#{@channels[0].sequential_id}-#{@messages[0].sequential_id}</a>"
        link_1 = "<a href=\"#{project_channel_path(@project, @channels[0].slug)}##{@messages[1].sequential_id}\" class=\"message-mention\">:#{@channels[0].sequential_id}-#{@messages[1].sequential_id}</a>"

        parse_result = @message_mention_service.parse_mention(
            "This is a test comment which references :#{@channels[0].sequential_id}-#{@messages[0].sequential_id} and :#{@channels[0].sequential_id}-#{@messages[1].sequential_id}",
            @project
        )
        expect(parse_result[:filtered_content]).to eq(
          "This is a test comment which references #{link_0} and #{link_1}"
        )
      end

      it 'would not replaced pattern :CHANNEL_ID-MESSAGE_ID with a link if message is not exist' do
        paragraph = "This is a test comment which references :10-NOT_EXIST_MESSAGE."
        parse_result = @message_mention_service.parse_mention(paragraph, @project)
        expect(parse_result[:filtered_content]).to eq(paragraph)
      end

      it 'would return the messages it parsed out' do
        parse_result = @message_mention_service.parse_mention(
            "This is a test comment which references :#{@channels[0].sequential_id}-#{@messages[0].sequential_id} and :#{@channels[0].sequential_id}-#{@messages[1].sequential_id}",
            @project
        )
        expect(parse_result[:mentioned_messages]).to eq([ @messages[0], @messages[1] ])
      end

      it 'would not return the messages if messages are not exist' do
        paragraph = "This is a test comment which references :10-NOT_EXIST_MESSAGE."
        parse_result = @message_mention_service.parse_mention(paragraph, @project)
        expect(parse_result[:mentioned_messages]).to eq([])
      end

    end
  end
end
