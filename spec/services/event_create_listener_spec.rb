require 'rails_helper'

RSpec.describe EventCreateListener do

  include_context 'issue sprint with project members and labels'

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

    end
  end
end