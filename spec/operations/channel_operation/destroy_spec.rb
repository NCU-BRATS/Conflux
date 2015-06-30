require 'rails_helper'

RSpec.describe ChannelOperation::Destroy do

  include_context 'channel with project and members'

  subject { ChannelOperation::Destroy.new(@members[0], @project, @channel) }

  describe '#process' do
    context 'when called' do

      it 'destroys the channel' do
        subject.process
        expect( @channel.destroyed? ).to be true
      end

      it 'fires corresponding event' do
        expect{ subject.process }.to broadcast( :on_channel_deleted )
      end

    end

  end
end
