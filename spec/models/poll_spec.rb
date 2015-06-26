require 'rails_helper'

RSpec.describe Poll, type: :model do
  let(:poll) { FactoryGirl.create(:poll) }

  it 'use the sequential_id as param' do
    expect(poll.to_param).to eq(poll.sequential_id.to_s)
  end

  it 'use the sequential_id as commentable key' do
    expect(Poll.commentable_find_key).to eq(:sequential_id)
  end

  context 'when having two polling options' do
    before(:example) do
      poll.options << FactoryGirl.create(:polling_option)
      poll.options << FactoryGirl.create(:polling_option)
      poll.options[0].voted_by(FactoryGirl.create(:user))
    end

    it 'sort options asc' do
      options = poll.reload.options
      expect(options[0].created_at).to be < options[1].created_at
    end

    context 'after being closed' do
      before(:example) { poll.close! }
      it 'cache the result options in results field' do
        expect(poll.results[0]['id']).to eq(poll.options[0].id)
      end
    end

    context 'after being reopened' do
      before(:example) { poll.close && poll.reopen! }
      it 'clean the result cache from results field' do
        expect(poll.results).to be_empty
      end
    end
  end
end
