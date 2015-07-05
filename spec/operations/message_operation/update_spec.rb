require 'rails_helper'

RSpec.describe MessageOperation::Update do

  include_context 'message with its channel project and member'

  subject { MessageOperation::Update.new(@members[0], @message) }

  describe '#process' do

    context 'when given valid params' do

      it 'changes the content' do
        subject.process( new_param( { message: { content: 'change' } } ) )
        expect( @message.content ).to eq 'change'
      end

    end

    context 'when given incorrect params' do
      it 'raises ActionController::ParameterMissing' do
        expect{ MessageOperation::Update.new(@members[0], @message).process(new_param) }.to raise_error ActionController::ParameterMissing
      end
    end

  end

end

