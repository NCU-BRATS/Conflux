require 'rails_helper'

RSpec.describe SprintMentionService do

  include_context 'project with members and sprints'
  include Rails.application.routes.url_helpers

  describe '#process' do
    context do

      before(:example) do
        @sprint_mention_service = SprintMentionService.new
      end

      it 'replaces pattern ##SPRINT_ID with a link to the sprint' do
        link_0 = "<a href=\"#{project_sprint_path(@project, @sprints[0])}\" class=\"sprint-mention\">###{@sprints[0].sequential_id}</a>"
        link_1 = "<a href=\"#{project_sprint_path(@project, @sprints[1])}\" class=\"sprint-mention\">###{@sprints[1].sequential_id}</a>"

        parse_result = @sprint_mention_service.parse_mention(
            "This is a test comment which references ###{@sprints[0].sequential_id} and ###{@sprints[1].sequential_id}",
            @project
        )
        expect(parse_result[:filtered_content]).to eq(
          "This is a test comment which references #{link_0} and #{link_1}"
        )
      end

      it 'would not replaced pattern ##SPRINT_ID with a link if sprint is not exist' do
        paragraph = "This is a test comment which references ##NOT_EXIST_SPRINT."
        parse_result = @sprint_mention_service.parse_mention(paragraph, @project)
        expect(parse_result[:filtered_content]).to eq(paragraph)
      end

      it 'would return the sprints it parsed out' do
        parse_result = @sprint_mention_service.parse_mention(
            "This is a test comment which references ###{@sprints[0].sequential_id} and ###{@sprints[1].sequential_id}",
            @project
        )
        expect(parse_result[:mentioned_sprints]).to eq([ @sprints[0], @sprints[1] ])
      end

      it 'would not return the sprints if sprints are not exist' do
        paragraph = "This is a test comment which references ##NOT_EXIST_SPRINT."
        parse_result = @sprint_mention_service.parse_mention(paragraph, @project)
        expect(parse_result[:mentioned_sprints]).to eq([])
      end

    end
  end
end
