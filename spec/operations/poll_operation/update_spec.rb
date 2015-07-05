require 'rails_helper'

RSpec.describe PollOperation::Update do

  include_context 'poll with options'

  subject { PollOperation::Update.new(@members[0], @poll) }

  describe '#process' do

    context 'when given valid params' do

      it 'changes the title' do
        subject.process(new_param({ poll: { title: 'title_changed' } }))
        expect( @poll.title ).to eq 'title_changed'
      end

      it 'changes the allow_multiple_choice' do
        subject.process(new_param({ poll: { allow_multiple_choice: 1 } }))
        expect( @poll.allow_multiple_choice ).to eq true
      end

      it 'builds new options' do
        subject.process(new_param({ poll: {
          options_attributes: { '0': { 'title': 'new_option' } }
        }}))
        find_created = @poll.options.find {|options| options.title == 'new_option'}
        expect( find_created ).not_to be nil
      end

      it 'updates options' do
        subject.process(new_param({ poll: {
          options_attributes: { '0': { 'title': 'title_changed2', 'id': @options[0].id } }
        }}))
        expect( @options[0].title ).to eq 'title_changed2'
      end

      it 'removes options' do
        subject.process(new_param({ poll: {
          options_attributes: { '0': { 'id': @options[0].id, '_destroy': '1' } }
        }}))
        expect( @options[0].destroyed? ).to be true
      end

    end

    context 'when given params without poll' do
      it 'raise ActionController::ParameterMissing' do
        expect{ subject.process(new_param) }.to raise_error ActionController::ParameterMissing
      end
    end

  end
end
