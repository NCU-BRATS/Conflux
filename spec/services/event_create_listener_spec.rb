require 'rails_helper'

RSpec.describe EventCreateListener do

  include_context 'issue sprint with project members and labels'
  include_context 'poll with options'
  include_context 'comment with commentable project and user'
  include_context 'channel with project and members'

  describe '#process' do
    context 'when given valid params' do
      before(:context) do

      end

      it 'create a event when a issue is created' do
        event = EventCreateListener.on_issue_created(@issue,@members[0])
        condiction = [
            event.project == @issue.project,
            event.target_id == @issue.id,
            event.target_type == @issue.class.name,
            event.author_id == @members[0].id,
            event.created? == true
        ]
        expect(condiction).to all( be true )
      end

      it 'create a event when a issue is closed' do
        event = EventCreateListener.on_issue_closed(@issue,@members[0])
        condiction = [
            event.project == @issue.project,
            event.target_id == @issue.id,
            event.target_type == @issue.class.name,
            event.author_id == @members[0].id,
            event.closed? == true
        ]
        expect(condiction).to all( be true )
      end

      it 'create a event when a issue is reopened' do
        event = EventCreateListener.on_issue_reopened(@issue,@members[0])
        condiction = [
            event.project == @issue.project,
            event.target_id == @issue.id,
            event.target_type == @issue.class.name,
            event.author_id == @members[0].id,
            event.reopened? == true
        ]
        expect(condiction).to all( be true )
      end

      it 'create a event when a sprint is created' do
        event = EventCreateListener.on_sprint_created(@sprint,@members[0])
        condiction = [
            event.project == @sprint.project,
            event.target_id == @sprint.id,
            event.target_type == @sprint.class.name,
            event.author_id == @members[0].id,
            event.created? == true
        ]
        expect(condiction).to all( be true )
      end

      it 'create a event when a sprint is closed' do
        event = EventCreateListener.on_sprint_closed(@sprint,@members[0])
        condiction = [
            event.project == @sprint.project,
            event.target_id == @sprint.id,
            event.target_type == @sprint.class.name,
            event.author_id == @members[0].id,
            event.closed? == true
        ]
        expect(condiction).to all( be true )
      end

      it 'create a event when a sprint is reopened' do
        event = EventCreateListener.on_sprint_reopened(@sprint,@members[0])
        condiction = [
            event.project == @sprint.project,
            event.target_id == @sprint.id,
            event.target_type == @sprint.class.name,
            event.author_id == @members[0].id,
            event.reopened? == true
        ]
        expect(condiction).to all( be true )
      end

      it 'create a event when a poll is created' do
        event = EventCreateListener.on_poll_created(@poll,@members[0])
        condiction = [
            event.project == @poll.project,
            event.target_id == @poll.id,
            event.target_type == @poll.class.name,
            event.author_id == @members[0].id,
            event.created? == true
        ]
        expect(condiction).to all( be true )
      end

      it 'create a event when a poll is closed' do
        event = EventCreateListener.on_poll_closed(@poll,@members[0])
        condiction = [
            event.project == @poll.project,
            event.target_id == @poll.id,
            event.target_type == @poll.class.name,
            event.author_id == @members[0].id,
            event.closed? == true
        ]
        expect(condiction).to all( be true )
      end

      it 'create a event when a poll is reopened' do
        event = EventCreateListener.on_poll_reopened(@poll,@members[0])
        condiction = [
            event.project == @poll.project,
            event.target_id == @poll.id,
            event.target_type == @poll.class.name,
            event.author_id == @members[0].id,
            event.reopened? == true
        ]
        expect(condiction).to all( be true )
      end

      it 'create a event when a comment is created' do
        event = EventCreateListener.on_comment_created(@comment,@members[0])
        condiction = [
            event.project == @comment.project,
            event.target_id == @comment.id,
            event.target_type == @comment.class.name,
            event.author_id == @members[0].id,
            event.commented? == true
        ]
        expect(condiction).to all( be true )
      end

      it 'create a event when a channel is created' do
        event = EventCreateListener.on_channel_created(@channel,@members[0])
        condiction = [
            event.project == @channel.project,
            event.target_id == @channel.id,
            event.target_type == @channel.class.name,
            event.author_id == @members[0].id,
            event.created? == true
        ]
        expect(condiction).to all( be true )
      end

    end
  end
end