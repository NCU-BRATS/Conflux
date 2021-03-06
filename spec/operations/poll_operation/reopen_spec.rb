require 'rails_helper'

RSpec.describe PollOperation::Reopen do

  include_context 'first poll option was voted by first member'

  before(:example) { @poll.close }

  describe '#process' do
    context 'when success' do

      let(:success) { PollOperation::Reopen.new(@members[0], @poll).process }

      it 'reopens the poll' do
        success
        expect( @poll.open? ).to be true
      end

      it 'cleans the result cache from results field' do
        success
        expect( @poll.results ).to be_empty
      end

      it 'fires on_poll_reopened event' do
        expect { success }.to broadcast(:on_poll_reopened)
      end

    end
  end
end
