require 'rails_helper'

RSpec.describe BroadcastService do

  include_context 'comment with commentable project and user'

  describe '#process' do
    context 'when given valid params' do

      it 'fire a broadcast to event create listener' do

        expect(EventCreateListener).to receive(:on_issue_created).with(@issue,@members[0])
        BroadcastService.fire(:on_issue_created, @issue, @members[0])

      end

      it 'fire a broadcast to notice create listener' do

        expect(NoticeCreateListener).to receive(:on_issue_created).with(@issue,@members[0])
        BroadcastService.fire(:on_issue_created, @issue, @members[0])

      end

      it 'get broadcast service instances' do
        @broadcast_service = BroadcastService.instance
        broadcast_service = BroadcastService.instance
        conditions = [
            @broadcast_service.class.name == BroadcastService.name,
            @broadcast_service.equal?(broadcast_service) == true
        ]
        expect( conditions ).to all( be true )
      end

    end
  end
end

class BroadcastServiceSpec
  class << self
    def test_for_broadcastService
      $test_for_broadcastService = true
    end
  end
end