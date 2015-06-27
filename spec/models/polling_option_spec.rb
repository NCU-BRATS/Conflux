require 'rails_helper'

RSpec.describe PollingOption, type: :model do
  let(:option) { FactoryGirl.create(:polling_option) }
  let(:user)   { FactoryGirl.create(:user) }

  before(:example) { option.voted_by(user) }

  describe '#votes_total' do
    it 'return amount of total voted users' do
      expect(option.votes_total).to eq(1)
    end
  end

  describe '#voted_by?' do
    context 'if voted by the given user' do
      it 'return true' do
        expect(option.voted_by?(user)).to eq true
      end
    end

    context 'if not voted by the given user' do
      it 'return false' do
        expect(option.voted_by?(FactoryGirl.create(:user))).to eq false
      end
    end
  end

  describe '#voted_by' do
    it 'add the given user to voted_users field' do
      expect(option.voted_users).to include(user)
    end
  end

  describe '#unvoted_by' do
    before(:example) { option.unvoted_by(user) }
    it 'remove the given user from voted_users field' do
      expect(option.voted_users).not_to include(user)
    end
  end
end
