require 'rails_helper'

RSpec.describe IssueMentionService do

  include_context 'project with members and attachments'
  include Rails.application.routes.url_helpers

  describe '#process' do
    context do

      before(:example) do
        @attachment_mention_service = AttachmentMentionService.new
      end

      it 'replaces pattern ~ATTACHMENT_ID with a link to the attachment' do
        link_0 = "<a href=\"#{project_attachment_path(@project, @attachments[0])}\" class=\"attachment-mention\">~#{@attachments[0].sequential_id}</a>"
        link_1 = "<a href=\"#{project_attachment_path(@project, @attachments[1])}\" class=\"attachment-mention\">~#{@attachments[1].sequential_id}</a>"

        parse_result = @attachment_mention_service.parse_mention(
            "This is a test comment which references ~#{@attachments[0].sequential_id} and ~#{@attachments[1].sequential_id}",
            @project
        )
        expect(parse_result[:filtered_content]).to eq(
          "This is a test comment which references #{link_0} and #{link_1}"
        )
      end

      it 'would not replaced pattern ~ATTACHMENT_ID with a link if attachment is not exist' do
        paragraph = "This is a test comment which references ~NOT_EXIST_ATTACHMENT."
        parse_result = @attachment_mention_service.parse_mention(paragraph, @project)
        expect(parse_result[:filtered_content]).to eq(paragraph)
      end

      it 'would return the attachments it parsed out' do
        parse_result = @attachment_mention_service.parse_mention(
            "This is a test comment which references ~#{@attachments[0].sequential_id} and ~#{@attachments[1].sequential_id}",
            @project
        )
        expect(parse_result[:mentioned_attachments]).to eq([ @attachments[0], @attachments[1] ])
      end

      it 'would not return the attachments if attachments are not exist' do
        paragraph = "This is a test comment which references ~NOT_EXIST_ATTACHMENT."
        parse_result = @attachment_mention_service.parse_mention(paragraph, @project)
        expect(parse_result[:mentioned_attachments]).to eq([])
      end

    end
  end
end
