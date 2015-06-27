require 'rails_helper'

RSpec.describe PollingOptionOperation::Vote do
  include_context 'first poll option was voted by first member'

  before(:example) do
    @user_voted = @members[0]
    @user_not_voted = @members[1]
  end

  subject { PollingOptionOperation::Vote }

  describe '#process' do
    context 'if the option was voted by the user' do
      it 'unvote the option' do
        subject.new(@user_voted, @poll, @options[0]).process
        expect(@options[0].voted_by?(@user_voted)).to be false
      end
    end

    context 'if the option was not voted by the user' do
      it 'vote the option' do
        subject.new(@user_not_voted, @poll, @options[0]).process
        expect(@options[0].voted_by?(@user_not_voted)).to be true
      end

      it 'add the user into poll participation' do
        subject.new(@user_not_voted, @poll, @options[0]).process
        expect(@poll.participations.find {|p| p.user_id == @user_not_voted.id}).not_to be nil
      end
    end

    context 'if multiple votes is allowed' do
      it 'can vote on multiple options' do
        @poll.allow_multiple_choice = true
        @options.each do |option|
          PollingOptionOperation::Vote.new(@user_not_voted, @poll, option).process
        end
        results = @options.map {|option| option.voted_by?(@user_not_voted) }
        expect(results).to all( be true )
      end
    end

    context 'if multiple votes is not allowed' do
      it 'can only vote on one option' do
        @poll.allow_multiple_choice = false
        @options.each do |option|
          PollingOptionOperation::Vote.new(@user_not_voted, @poll, option).process
        end
        results = @options.map {|option| option.voted_by?(@user_not_voted) }
        expect(results.select {|e| e == true}.size).to be 1
      end
    end

    context 'if poll is close' do
      it 'can not be voted' do
        @poll.close!
        PollingOptionOperation::Vote.new(@user_not_voted, @poll, @options[0]).process
        expect(@options[0].voted_by?(@user_not_voted)).to be false
      end

      it 'can not be unvoted' do
        @poll.close!
        PollingOptionOperation::Vote.new(@user_voted, @poll, @options[0]).process
        expect(@options[0].voted_by?(@user_voted)).to be true
      end
    end
  end
end
