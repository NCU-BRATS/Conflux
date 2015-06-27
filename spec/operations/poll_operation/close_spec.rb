require 'rails_helper'

RSpec.describe PollOperation::Close do
  include_context 'first poll option was voted by first member'

  describe '#process' do
    context 'when success' do
      let(:success) { PollOperation::Close.new(@members[0], @poll).process }

      it 'closes the poll' do
        success
        expect(@poll.closed?).to be true
      end

      it 'cache the result options in results field' do
        success
        expect(@poll.results[0]['id']).to eq(@poll.options[0].id)
      end

      it 'fires on_poll_closed event' do
        expect { success }.to broadcast(:on_poll_closed)
      end
    end
  end
end
