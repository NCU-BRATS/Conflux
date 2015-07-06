require 'rails_helper'

RSpec.describe BroadcastService do

  include_context 'comment with commentable project and user'

  describe '#process' do
    context 'when given valid params' do

      around(:each) do |example|
        BroadcastService.listener_toggle = true
        example.run
        BroadcastService.listener_toggle = false
      end

      it 'fire a broadcast to event create listener' do

        expect(EventCreateListener).to receive(:on_issue_created).with(@issue,@members[0])
        BroadcastService.fire(:on_issue_created, @issue, @members[0])

      end

      it 'fire a broadcast to notice create listener' do

        expect(NoticeCreateListener).to receive(:on_issue_created).with(@issue,@members[0])
        BroadcastService.fire(:on_issue_created, @issue, @members[0])

      end

    end
  end
end
