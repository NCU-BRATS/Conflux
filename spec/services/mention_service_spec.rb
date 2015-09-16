require 'rails_helper'

RSpec.describe MentionService do

  include_context 'project with mentionable resources'
  include Rails.application.routes.url_helpers

  describe '#process' do
    it 'replaces all mentioned resource with a link' do
      link_user = "<a href=\"#{user_path(@members[0])}\" class=\"user-mention\">@#{@members[0].name}</a>"
      link_attachment = "<a href=\"#{project_attachment_path(@project, @attachments[0])}\" class=\"attachment-mention\">$#{@attachments[0].sequential_id}</a>"
      link_issue = "<a href=\"#{project_issue_path(@project, @issues[0])}\" class=\"issue-mention\">##{@issues[0].sequential_id}</a>"
      link_poll = "<a href=\"#{project_poll_path(@project, @polls[0])}\" class=\"poll-mention\">^#{@polls[0].sequential_id}</a>"
      link_sprint = "<a href=\"#{project_sprint_path(@project, @sprints[0])}\" class=\"sprint-mention\">###{@sprints[0].sequential_id}</a>"
      link_message = "<a href=\"#{project_channel_path(@project, @channels[0].slug)}##{@messages[0].sequential_id}\" class=\"message-mention\">:#{@channels[0].sequential_id}-#{@messages[0].sequential_id}</a>"

      content, mentioned = MentionService.parse_mentioned(
          "This is a test comment which references @#{@members[0].name}, $#{@attachments[0].sequential_id}, " +
          "##{@issues[0].sequential_id}, ^#{@polls[0].sequential_id}, :#{@channels[0].sequential_id}-#{@messages[0].sequential_id} and ###{@sprints[0].sequential_id}", @project)
      expect(content).to eq("This is a test comment which references #{link_user}, #{link_attachment}, #{link_issue}, #{link_poll}, #{link_message} and #{link_sprint}")
    end

    it 'would return the id of resources it parsed out as a hash ' do
      content, mentioned = MentionService.parse_mentioned(
          "This is a test comment which references @#{@members[0].name}, $#{@attachments[0].sequential_id}, " +
              "##{@issues[0].sequential_id}, ^#{@polls[0].sequential_id}, :#{@channels[0].sequential_id}-#{@messages[0].sequential_id} and ###{@sprints[0].sequential_id}", @project)
      expect(mentioned).to eq({
                               "members" => [@members[0].id],
                               "attachments" => [@attachments[0].sequential_id],
                               "issues" => [@issues[0].sequential_id],
                               "polls" => [@polls[0].sequential_id],
                               "sprints" => [@sprints[0].sequential_id],
                              "messages" => [@messages[0].sequential_id]
                              })
    end
  end
end
